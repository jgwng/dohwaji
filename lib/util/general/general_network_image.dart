import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CachedImage extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  final BoxBorder? border;
  final BorderRadius? borderRadius;
  final bool isCircular;
  final BoxFit? fit;
  final Color? filterColor;
  final FilterQuality? filterQuality;
  final Color? placeHolderColor;
  final Alignment? alignment;
  final bool useCacheKey;
  const CachedImage({
    super.key,
    required this.url,
    required this.height,
    required this.width,
    this.border,
    this.borderRadius,
    this.isCircular = false,
    this.fit,
    this.filterColor,
    this.filterQuality,
    this.placeHolderColor,
    this.alignment,
    this.useCacheKey = false,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      filterQuality: filterQuality ?? FilterQuality.low,
      cacheKey: _cacheKey,
      imageBuilder: (context, image) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
            border: border,
            borderRadius: borderRadius,
            image: DecorationImage(
              image: image,
              fit: fit ?? BoxFit.cover,
              alignment: alignment ?? Alignment.center,
              colorFilter: (filterColor != null)
                  ? ColorFilter.mode(filterColor!, BlendMode.overlay)
                  : null,
            ),
          ),
        );
      },
      imageUrl: url,
      width: width,
      height: height,
      placeholder: (_, url) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: (isCircular == false) ? (borderRadius ?? BorderRadius.zero) : null,
          color: placeHolderColor ?? Colors.red,
        ),
      ),
      errorWidget: (_, url, error) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: (isCircular == false) ? (borderRadius ?? BorderRadius.zero) : null,
          color: placeHolderColor ?? Colors.red,
        ),
      ),
    );
  }

  String get _cacheKey {
    if(useCacheKey == false) return url;
    final now = DateTime.now();
    return '$url-${now.year}-${now.month}-${now.day}-${now.hour}';
  }
}