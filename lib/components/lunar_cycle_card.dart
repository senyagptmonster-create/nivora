import 'package:flutter/material.dart';
import '../theme/nivora_theme.dart';

class LunarCycleCard extends StatelessWidget {
  final double phase; // 0.0 to 1.0 (0 = New Moon, 0.5 = Full Moon)
  final String phaseName;

  const LunarCycleCard({
    super.key,
    required this.phase,
    required this.phaseName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: NivoraPalette.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: NivoraPalette.edge),
        boxShadow: [
          BoxShadow(
            color: NivoraPalette.accent.withAlpha(25),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          CustomPaint(
            size: const Size(100, 100),
            painter: _MoonPainter(phase),
          ),
          const SizedBox(height: 16),
          Text(
            phaseName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: NivoraPalette.ink,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Illumination: ${(phase <= 0.5 ? phase * 200 : (1.0 - phase) * 200).toInt()}%',
            style: const TextStyle(
              fontSize: 13,
              color: NivoraPalette.accent2,
            ),
          ),
        ],
      ),
    );
  }
}

class _MoonPainter extends CustomPainter {
  final double phase;
  _MoonPainter(this.phase);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Dark side
    final darkPaint = Paint()..color = NivoraPalette.edge;
    canvas.drawCircle(center, radius, darkPaint);

    // Glowing accent
    final lightPaint = Paint()..color = NivoraPalette.accent2;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.57,
      3.14,
      false,
      lightPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _MoonPainter oldDelegate) => oldDelegate.phase != phase;
}
