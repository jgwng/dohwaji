import 'package:flutter/material.dart';

class TornPaper extends StatelessWidget {
  const TornPaper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Painted Torn Paper')),
      body: Center(
        child: CustomPaint(
          painter: TornPaperPainter(),
          size: const Size(300, 100),
        ),
      ),
    );
  }
}

class TornPaperPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = Colors.grey.shade300;
    final Path path = Path();

    // Start from the top left corner
    path.moveTo(0, 0);

    // Create the irregular top edge
    final double topEdgeControlHeight = size.width * 0.05;
    const int topSplits = 20;
    for (int i = 0; i < topSplits; i++) {
      final bool isOdd = i.isOdd;
      final double dy = (size.height / topSplits) * (i + 1);
      final double dx = isOdd ? topEdgeControlHeight : 0;
      path.lineTo(dx, dy);
    }

    // Draw the right side down
    path.lineTo(size.width, size.height);

    // Create the irregular bottom edge
    final double bottomEdgeControlHeight = size.height * 0.1;
    const int bottomSplits = 10;
    for (int i = bottomSplits; i >= 0; i--) {
      final bool isOdd = i.isOdd;
      final double dy = (size.height / bottomSplits) * i;
      final double dx = size.width - (isOdd ? bottomEdgeControlHeight : 0);
      path.lineTo(dx, dy);
    }

    // Draw the left side up
    // path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);

    // Adding shadows for a 3D effect
    // canvas.drawShadow(path, Colors.black, 3.0, false);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
