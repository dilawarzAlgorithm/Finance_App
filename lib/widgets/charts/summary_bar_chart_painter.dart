import 'package:flutter/material.dart';

class SummaryBarPainter extends CustomPainter {
  final double totalIn;
  final double totalOut;
  final double animationFactor;

  SummaryBarPainter({
    required this.totalIn,
    required this.totalOut,
    required this.animationFactor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final double total = totalIn + totalOut;

    if (total == 0) return;

    final double cornerRadius = 8.0;
    final double spacing = 4.0;
    final double barHeight = size.height;

    double inWidth = (totalIn / total) * size.width;
    double outWidth = (totalOut / total) * size.width;

    inWidth *= animationFactor;
    outWidth *= animationFactor;

    paint.color = Colors.green.shade400;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, inWidth, barHeight),
        Radius.circular(cornerRadius),
      ),
      paint,
    );

    paint.color = Colors.red.shade400;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(inWidth + spacing, 0, outWidth, barHeight),
        Radius.circular(cornerRadius),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
