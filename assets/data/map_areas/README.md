# Map area geometries

GeoJSON boundary files for drawing map areas on the cleanup map. Backend `map_areas` rows (captains, hotspots) are linked to these shapes via **slug**.

## Layout

```
map_areas/
  manifest.json              # Index of regions and layers — start here when adding data
  nyc/
    boroughs.geojson         # 5 NYC boroughs (matches backend seed slugs)
    neighborhoods.geojson    # 197 NYC DCP NTA2020 residential areas
```

## Neighborhood source

**NYC DCP NTA2020** — [2020 Neighborhood Tabulation Areas](https://data.cityofnewyork.us/City-Government/2020-Neighborhood-Tabulation-Areas-NTAs-/9nt8-h7nd) from NYC Department of City Planning.

Downloaded from the official ArcGIS FeatureServer, filtered to residential NTAs (`NTAType = 0`), simplified with Mapshaper (~10%), and normalized to WGS84.

NTA names roughly match common neighborhood names but are official statistical areas (some neighborhoods are merged). Slugs use stable NTA codes: `nyc-nta-bk0102` (Williamsburg), etc.

## Adding a new city or region

1. Create a folder, e.g. `austin/`.
2. Add one or more `.geojson` files (`FeatureCollection`, WGS84 lat/lng).
3. Add a `regions[]` entry in `manifest.json` with:
   - `assetPath` pointing at your file
   - `featureNameProperty` — GeoJSON property used as the display name
   - `slugMap`, `slugProperty`, and/or `slugFromName` to match backend `map_areas.slug` values
4. Seed corresponding rows in the backend (admin `POST /map-hotspots/areas` or a seed file).

## Slug linking

Backend areas use slugs like `nyc-manhattan`. Borough features in `boroughs.geojson` use the `borough` property; `manifest.json` maps those names to slugs.

NTA2020 neighborhoods use `slugProperty: nta2020` → slugs like `nyc-nta-mn0101`. Create matching backend areas when you assign neighborhood captains.

## Sources

- **Boroughs**: [haghard/streams-recipes](https://github.com/haghard/streams-recipes/blob/master/nyc-borough-boundaries-polygon.geojson)
- **Neighborhoods**: [NYC Open Data — NTA2020](https://data.cityofnewyork.us/City-Government/2020-Neighborhood-Tabulation-Areas-NTAs-/9nt8-h7nd) / [ArcGIS FeatureServer](https://services5.arcgis.com/GfwWNkhOj9bNBqoJ/arcgis/rest/services/NYC_Neighborhood_Tabulation_Areas_2020/FeatureServer/0)

Replace or simplify files with [Mapshaper](https://mapshaper.org/) if bundle size becomes an issue.
