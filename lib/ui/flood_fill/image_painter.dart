import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class ImagePainter extends CustomPainter {
  final ui.Image image;

  const ImagePainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(
        image, Offset.zero, Paint()..filterQuality = FilterQuality.high);
  }

  @override
  bool shouldRepaint(ImagePainter oldDelegate) => true;
}

class ImageTransitionPainter extends CustomPainter {
  final ui.Image image1;
  final ui.Image image2;
  final double animationValue;

  ImageTransitionPainter({
    required this.image1,
    required this.image2,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    // Draw the first image with decreasing opacity
    paint.colorFilter = ui.ColorFilter.mode(
      Colors.white
          .withOpacity(1), // Decrease opacity as the animation progresses
      BlendMode.modulate,
    );
    canvas.drawImage(image1, Offset.zero, paint);

    // Draw the second image with increasing opacity
    paint.colorFilter = ui.ColorFilter.mode(
      Colors.white.withOpacity(
          animationValue), // Increase opacity as the animation progresses
      BlendMode.modulate,
    );
    canvas.drawImage(image2, Offset.zero, paint);
  }

  @override
  bool shouldRepaint(covariant ImageTransitionPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
