import 'dart:math';
import 'package:flutter/material.dart';

class MoonPhasePainter extends CustomPainter {
  final double illumination; // 0.0 to 1.0

  MoonPhasePainter({required this.illumination});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;

    // Dark moon base
    final darkPaint = Paint()..color = const Color(0xFF1B2232);
    canvas.drawCircle(center, radius, darkPaint);

    // Glowing rim
    final rimPaint = Paint()
      ..color = const Color(0xFFE2E8F0).withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, rimPaint);

    // Illuminated phase crescent/gibbous
    final glowPaint = Paint()
      ..color = const Color(0xFFFFF7D6)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.arcTo(Rect.fromCircle(center: center, radius: radius), -pi / 2, pi, false);

    // Elliptical inner curve
    final sweep = (illumination - 0.5) * 2; // -1 to 1
    final innerRect = Rect.fromCenter(
      center: center,
      width: radius * 2 * sweep.abs(),
      height: radius * 2,
    );
    if (sweep >= 0) {
      path.arcTo(innerRect, pi / 2, -pi, false);
    } else {
      path.arcTo(innerRect, pi / 2, pi, false);
    }
    path.close();

    canvas.drawPath(path, glowPaint);
  }

  @override
  bool shouldRepaint(covariant MoonPhasePainter oldDelegate) =>
      oldDelegate.illumination != illumination;
}
