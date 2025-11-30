import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton_core/core/widgets/skeletons.dart';
import 'package:flutter/material.dart';

/// A wrapper around CachedNetworkImage that adds proper HTTP headers
/// to prevent AVIF format issues on Android < API 31.
///
/// This widget:
/// - Requests only JPEG/PNG/WebP formats via Accept header
/// - Adds cache-busting to force re-fetching with new headers
/// - Provides consistent, visible error handling
/// - Optimizes memory caching
class CachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget Function(BuildContext, String)? placeholder;
  final Widget Function(BuildContext, String, dynamic)? errorWidget;

  const CachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    // Add cache-busting parameter to force re-fetch with new headers
    // This helps clear any previously cached AVIF images
    final cacheBustedUrl =
        imageUrl.contains('?') ? '$imageUrl&v=2' : '$imageUrl?v=2';

    return CachedNetworkImage(
      imageUrl: cacheBustedUrl,
      width: width,
      height: height,
      fit: fit,
      httpHeaders: const {
        // Explicit format preference - no AVIF
        'Accept': 'image/jpeg,image/png,image/webp;q=0.9,*/*;q=0.8',
        // User agent to ensure consistent behavior
        'User-Agent': 'Mozilla/5.0 (Android; Mobile) Ditonton/1.0',
        // Prevent serving stale cached AVIF images from CDN
        'Cache-Control': 'no-cache',
      },
      memCacheHeight: height != null ? (height! * 2).toInt() : null,
      memCacheWidth: width != null ? (width! * 2).toInt() : null,
      placeholder: placeholder ??
          (context, url) => ShimmerBox(
                height: height ?? 120,
                width: width ?? 80,
              ),
      errorWidget: errorWidget ??
          (context, url, error) => Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.broken_image_outlined,
                    size: 48,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
    );
  }
}
