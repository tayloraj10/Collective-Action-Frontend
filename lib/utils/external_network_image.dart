import 'dart:typed_data';

import 'package:flutter/widgets.dart';

/// Cleans pasted third-party image URLs (trim, https, common HTML entities).
/// `data:image/...;base64,...` URIs are returned unchanged.
String normalizeExternalImageUrl(String raw) {
  var s = raw.trim();
  if (s.isEmpty) return s;
  if (s.startsWith('data:')) {
    return s;
  }
  s = s.replaceAll('&amp;', '&');
  if (!s.startsWith('http://') && !s.startsWith('https://')) {
    if (s.startsWith('//')) {
      s = 'https:$s';
    } else {
      s = 'https://$s';
    }
  }
  final uri = Uri.tryParse(s);
  if (uri == null) return s;
  return uri.toString();
}

/// Decodes a `data:image/...` URI to bytes. Returns null if not a valid image data URI.
/// [NetworkImage] cannot load data URIs; use [Image.memory] with these bytes instead.
Uint8List? decodeDataUriImageBytes(String raw) {
  final s = raw.trim();
  if (!s.startsWith('data:')) return null;
  final uri = Uri.tryParse(s);
  final data = uri?.data;
  if (data == null) return null;
  try {
    return data.contentAsBytes();
  } catch (_) {
    return null;
  }
}

/// [NetworkImage] for http(s) URLs. On web, prefers an HTML &lt;img&gt; so public CDNs
/// are not blocked by fetch CORS. Does not work for `data:` URIs — use
/// [decodeDataUriImageBytes] + [Image.memory] instead.
ImageProvider<Object> externalNetworkImageProvider(String url) {
  return NetworkImage(
    normalizeExternalImageUrl(url),
    webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
  );
}

/// Thumbnail / inline image: supports **https** URLs and **`data:image/...;base64,...`** embeds.
class ExternalOrDataImage extends StatelessWidget {
  const ExternalOrDataImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.errorBuilder,
    this.preferHtmlElementOnWeb = true,
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Alignment alignment;
  final ImageErrorWidgetBuilder? errorBuilder;
  final bool preferHtmlElementOnWeb;

  @override
  Widget build(BuildContext context) {
    final bytes = decodeDataUriImageBytes(url);
    if (bytes != null) {
      return Image.memory(
        bytes,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        errorBuilder: errorBuilder,
      );
    }
    return Image(
      image: NetworkImage(
        normalizeExternalImageUrl(url),
        webHtmlElementStrategy: preferHtmlElementOnWeb
            ? WebHtmlElementStrategy.prefer
            : WebHtmlElementStrategy.never,
      ),
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      errorBuilder: errorBuilder,
    );
  }
}
