import 'package:flutter/material.dart';

class RadarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Color(0xFF2AB82D)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const double step = 90.0; // Increase the step value for a less dense grid

    // Draw vertical lines
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal lines
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Draw text -180° at the top left
    final textPainterLeft = TextPainter(
      text: const TextSpan(
        text: '-180°',
        style: TextStyle(
          color: Color(0xFF2AB82D),
          fontSize: 14,
          fontFamily: 'pcsenior'
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainterLeft.layout();
    textPainterLeft.paint(canvas, const Offset(10, 20));

    // Draw text 180° at the top right
    final textPainterRight = TextPainter(
      text: const TextSpan(
        text: '180°',
        style: TextStyle(
          color: Color(0xFF2AB82D),
          fontSize: 14,
          fontFamily: 'pcsenior'
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainterRight.layout();
    textPainterRight.paint(canvas, Offset(size.width - textPainterRight.width - 10, 20));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}