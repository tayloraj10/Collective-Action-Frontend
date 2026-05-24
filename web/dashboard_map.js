// Dashboard map helper: Google Maps base + deck.gl HeatmapLayer overlay.
// Replaces the removed google.maps.visualization.HeatmapLayer on web.
(function () {
  const instances = {};
  let nextId = 0;

  function ensureMapRegistry() {
    if (window.__flutterGoogleMapRegistry) return;
    if (!window.google || !window.google.maps || !window.google.maps.Map) return;
    window.__flutterGoogleMapRegistry = {};
    const OriginalMap = google.maps.Map;
    google.maps.Map = function (div, opts) {
      const map = new OriginalMap(div, opts);
      if (div && div.id) {
        window.__flutterGoogleMapRegistry[div.id] = map;
      }
      return map;
    };
  }

  ensureMapRegistry();
  const registryPoll = setInterval(function () {
    ensureMapRegistry();
    if (window.__flutterGoogleMapRegistry && window.google?.maps?.Map) {
      clearInterval(registryPoll);
    }
  }, 50);

  function flutterMapViewId(flutterMapId) {
    return 'plugins.flutter.io/google_maps_' + flutterMapId;
  }

  function getFlutterGoogleMap(flutterMapId) {
    ensureMapRegistry();
    return window.__flutterGoogleMapRegistry?.[flutterMapViewId(flutterMapId)];
  }

  function parseStyle(styleJson) {
    if (!styleJson) return [];
    try {
      return JSON.parse(styleJson);
    } catch (e) {
      return [];
    }
  }

  function computeBounds(points) {
    if (!points || points.length === 0) return null;
    let minLat = points[0].lat;
    let maxLat = points[0].lat;
    let minLng = points[0].lng;
    let maxLng = points[0].lng;
    for (const p of points) {
      minLat = Math.min(minLat, p.lat);
      maxLat = Math.max(maxLat, p.lat);
      minLng = Math.min(minLng, p.lng);
      maxLng = Math.max(maxLng, p.lng);
    }
    const latDiff = Math.abs(maxLat - minLat);
    const lngDiff = Math.abs(maxLng - minLng);
    const latPadding = latDiff < 0.002 ? 0.02 : 0;
    const lngPadding = lngDiff < 0.002 ? 0.02 : 0;
    return {
      sw: { lat: minLat - latPadding, lng: minLng - lngPadding },
      ne: { lat: maxLat + latPadding, lng: maxLng + lngPadding },
    };
  }

  // Classic Google Maps heatmap palette: blue → cyan → green → yellow → red.
  const HEATMAP_COLOR_RANGE = [
    [0, 0, 255],
    [0, 191, 255],
    [0, 255, 0],
    [255, 255, 0],
    [255, 128, 0],
    [255, 0, 0],
  ];

  function parseHeatmapConfig(configJson) {
    try {
      const parsed = JSON.parse(configJson);
      if (Array.isArray(parsed)) {
        return { points: parsed, zoom: null };
      }
      return {
        points: parsed.points || [],
        zoom: parsed.zoom != null ? Number(parsed.zoom) : null,
      };
    } catch (e) {
      return { points: [], zoom: null };
    }
  }

  function radiusPixelsForZoom(zoom) {
    if (zoom == null || Number.isNaN(zoom)) zoom = 10;
    // Larger, softer blobs when zoomed in so nearby points merge.
    const minRadius = 28;
    const maxRadius = 145;
    const lowZoom = 4;
    const highZoom = 14;
    const tLinear = Math.max(
      0,
      Math.min(1, (zoom - lowZoom) / (highZoom - lowZoom)),
    );
    const t = 1 - (1 - tLinear) * (1 - tLinear);
    return Math.round(minRadius + (maxRadius - minRadius) * t);
  }

  function createHeatmapLayer(points, zoom) {
    return new deck.HeatmapLayer({
      id: 'dashboard-heatmap',
      data: points,
      getPosition: function (d) {
        return [d.lng, d.lat];
      },
      getWeight: function (d) {
        return d.weight != null ? d.weight : 1;
      },
      radiusPixels: radiusPixelsForZoom(zoom),
      intensity: 1.6,
      threshold: 0.008,
      opacity: 0.65,
      colorRange: HEATMAP_COLOR_RANGE,
    });
  }

  function refreshHeatmapLayer(inst) {
    const zoom =
      inst.map && inst.map.getZoom ? inst.map.getZoom() : inst.zoom;
    const layer = createHeatmapLayer(inst.points || [], zoom);
    inst.overlay.setProps({ layers: [layer] });
  }

  function bindHeatmapZoomRefresh(inst) {
    if (!inst.map || inst.zoomListener) return;
    inst.zoomListener = inst.map.addListener('zoom_changed', function () {
      refreshHeatmapLayer(inst);
    });
  }

  function fitBoundsForMap(map, points, padding) {
    if (!points || points.length === 0) return;
    if (points.length === 1) {
      map.setCenter({ lat: points[0].lat, lng: points[0].lng });
      map.setZoom(10);
      return;
    }
    const bounds = computeBounds(points);
    if (!bounds) return;
    map.fitBounds(
      new google.maps.LatLngBounds(bounds.sw, bounds.ne),
      padding != null ? padding : 60,
    );
  }

  window.dashboardMapApi = {
    create: function (container, optionsJson) {
      if (!window.google || !window.google.maps || !window.deck) {
        return -1;
      }

      const options = JSON.parse(optionsJson);
      const id = nextId++;
      const points = options.points || [];

      const mapDiv = document.createElement('div');
      mapDiv.style.width = '100%';
      mapDiv.style.height = '100%';
      container.appendChild(mapDiv);

      const map = new google.maps.Map(mapDiv, {
        center: options.center,
        zoom: options.zoom,
        styles: parseStyle(options.styleJson),
        disableDefaultUI: true,
        gestureHandling: 'cooperative',
        clickableIcons: false,
      });

      const heatmapLayer = createHeatmapLayer(points, map.getZoom());
      const overlay = new deck.GoogleMapsOverlay({ layers: [heatmapLayer] });
      overlay.setMap(map);

      instances[id] = {
        map: map,
        overlay: overlay,
        mapDiv: mapDiv,
        points: points,
      };
      bindHeatmapZoomRefresh(instances[id]);

      fitBoundsForMap(map, points, options.padding);

      return id;
    },

    updateHeatmap: function (id, optionsJson) {
      const inst = instances[id];
      if (!inst) return;
      const config = parseHeatmapConfig(optionsJson);
      inst.points = config.points;
      if (config.zoom != null) {
        refreshHeatmapLayer({ overlay: inst.overlay, points: inst.points, zoom: config.zoom });
      } else {
        refreshHeatmapLayer(inst);
      }
    },

    setStyle: function (id, styleJson) {
      const inst = instances[id];
      if (!inst) return;
      inst.map.setOptions({ styles: parseStyle(styleJson) });
    },

    destroy: function (id) {
      const inst = instances[id];
      if (!inst) return;
      if (inst.zoomListener) {
        google.maps.event.removeListener(inst.zoomListener);
      }
      inst.overlay.setMap(null);
      if (inst.mapDiv) {
        inst.mapDiv.remove();
      }
      delete instances[id];
    },

    attachHeatmapToFlutterMap: function (flutterMapId, configJson) {
      if (!window.deck) return -1;
      const map = getFlutterGoogleMap(flutterMapId);
      if (!map) return -1;
      const config = parseHeatmapConfig(configJson);
      const id = nextId++;
      const zoom = config.zoom != null ? config.zoom : map.getZoom();
      const heatmapLayer = createHeatmapLayer(config.points, zoom);
      const overlay = new deck.GoogleMapsOverlay({ layers: [heatmapLayer] });
      overlay.setMap(map);
      instances[id] = {
        map: map,
        overlay: overlay,
        flutterMapId: flutterMapId,
        points: config.points,
      };
      bindHeatmapZoomRefresh(instances[id]);
      return id;
    },

    updateFlutterMapHeatmap: function (overlayId, configJson) {
      const inst = instances[overlayId];
      if (!inst) return;
      const config = parseHeatmapConfig(configJson);
      inst.points = config.points;
      if (config.zoom != null) {
        refreshHeatmapLayer({ overlay: inst.overlay, points: inst.points, zoom: config.zoom });
      } else {
        refreshHeatmapLayer(inst);
      }
    },

    detachHeatmap: function (overlayId) {
      const inst = instances[overlayId];
      if (!inst) return;
      if (inst.zoomListener) {
        google.maps.event.removeListener(inst.zoomListener);
      }
      inst.overlay.setMap(null);
      delete instances[overlayId];
    },
  };
})();
