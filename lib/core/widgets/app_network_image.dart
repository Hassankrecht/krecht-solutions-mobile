import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Shared network image widget with platform-specific loading behavior.
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit,
    this.width,
    this.height,
    this.placeholder,
    this.errorWidget,
  });

  final String imageUrl;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final WidgetBuilder? placeholder;
  final WidgetBuilder? errorWidget;

  @override
  Widget build(BuildContext context) {
    // On web, prefer the browser HTML image element for better compatibility
    // with remote images and CORS-sensitive rendering.
    if (kIsWeb) {
      return Image.network(
        key: ValueKey(imageUrl),
        imageUrl,
        fit: fit,
        width: width,
        height: height,
        webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
        loadingBuilder: placeholder == null
            ? null
            : (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return placeholder!(context);
              },
        errorBuilder: errorWidget == null
            ? null
            : (context, error, stackTrace) => errorWidget!(context),
      );
    }

    // On mobile/desktop, use cached_network_image to reuse downloaded images.
    return CachedNetworkImage(
      key: ValueKey(imageUrl),
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      placeholder: placeholder == null
          ? null
          : (context, url) => placeholder!(context),
      errorWidget: errorWidget == null
          ? null
          : (context, url, error) => errorWidget!(context),
    );
  }
}
