import 'dart:math';
import 'package:flutter/material.dart';
import 'package:finance_app/core/data/models/category_model.dart';

class FinanceChartPainter extends CustomPainter {
  final Map<int, double> categorySpending;
  final Map<int, CategoryModel> categoryMap;
  final double animationFactor;

  FinanceChartPainter({
    required this.categorySpending,
    required this.categoryMap,
    required this.animationFactor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (categorySpending.isEmpty) return;

    final double total = categorySpending.values.fold(0, (a, b) => a + b);
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = min(size.width / 2, size.height / 2);
    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    double startAngle = -pi / 2;

    for (var entry in categorySpending.entries) {
      final category = categoryMap[entry.key];
      final sweepAngle = (entry.value / total) * 2 * pi * animationFactor;

      final paint = Paint()
        ..color = category?.color ?? Colors.grey
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;

      canvas.drawArc(rect, startAngle, sweepAngle, true, paint);

      startAngle += sweepAngle;
    }

    final holePaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, radius * 0.6, holePaint);
  }

  @override
  bool shouldRepaint(covariant FinanceChartPainter oldDelegate) {
    return oldDelegate.categorySpending != categorySpending ||
        oldDelegate.animationFactor != animationFactor;
  }
}
