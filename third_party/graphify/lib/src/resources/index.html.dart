// ignore_for_file: leading_newlines_in_multiline_strings

import 'package:graphify/src/controller/js_methods.dart';

String indexHtml({ required String id, String? dependencies}) {
  return '''<!DOCTYPE html>
    <html>
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
      <style>
        html, body {
          background-color: transparent;
          height: -webkit-fill-available;
          box-sizing: content-box;
          margin: 0;
          overflow: hidden;
          width: 100%;
          height: 100%;
        }
        #chart { height: -webkit-fill-available; }
      </style>
    </head>
    <body>
      <div id="chart"></div>
      ${dependencies ?? ''}
      <script>
          const dom = document.getElementById('chart');
          const context = (window.parent && window.parent.window) || window || {};
          const chart = context.echarts.init(dom, 'dark', { renderer: 'canvas', useDirtyRect: false });
          const originalUpdateChart =
            context.${JsMethods.updateChart} &&
            context.${JsMethods.updateChart}.bind(context);
          let updateToken = 0;

          function applyNodeImageFallbacks(options, done) {
            if (!options || !Array.isArray(options.series)) {
              done(options || {});
              return;
            }

            let pending = 0;
            let completed = false;

            function finish() {
              if (completed) return;
              if (pending > 0) return;
              completed = true;
              done(options);
            }

            for (const series of options.series) {
              const data = Array.isArray(series && series.data) ? series.data : [];
              for (const node of data) {
                const symbol = (node && typeof node.symbol === 'string') ? node.symbol : '';
                if (!symbol.startsWith('image://')) continue;

                const imageUrl = symbol.slice(8);
                if (!imageUrl) {
                  node.symbol = 'circle';
                  continue;
                }

                pending += 1;
                const img = new Image();
                img.crossOrigin = 'anonymous';
                let settled = false;
                const settle = function(useFallback) {
                  if (settled) return;
                  settled = true;
                  clearTimeout(timer);
                  if (useFallback) {
                    node.symbol = 'circle';
                  }
                  pending -= 1;
                  finish();
                };
                const timer = setTimeout(function() { settle(true); }, 1800);
                img.onload = function() { settle(false); };
                img.onerror = function() { settle(true); };
                try {
                  img.src = imageUrl;
                } catch (_) {
                  settle(true);
                }
              }
            }

            finish();
          }

          if (originalUpdateChart) {
            context.${JsMethods.updateChart} = function(chartId, options) {
              const token = ++updateToken;
              applyNodeImageFallbacks(options, function(resolvedOptions) {
                if (token !== updateToken) return;
                originalUpdateChart(chartId, resolvedOptions);
              });
            };
          }

          chart.on('click', function(params) {
            if (!params || params.dataType !== 'node') return;
            const payload = JSON.stringify({
              type: 'node_click',
              chartId: '$id',
              dataType: params.dataType,
              seriesType: params.seriesType,
              data: params.data || null,
              name: params.name || null,
            });
            try {
              if (window.GraphifyChannel && window.GraphifyChannel.postMessage) {
                window.GraphifyChannel.postMessage(payload);
              }
            } catch (_) {}
            try {
              if (window.parent && window.parent.postMessage) {
                window.parent.postMessage(payload, '*');
              }
            } catch (_) {}
          });
          context.${JsMethods.initChart}('$id', chart, {});
          context.${JsMethods.updateChart}('$id', {});
          window.addEventListener('resize', chart.resize);
      </script>
    </body>
    </html>
''';
}
