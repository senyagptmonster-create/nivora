import 'package:flutter/material.dart';
import '../components/lunar_cycle_card.dart';
import '../theme/nivora_theme.dart';

class LunarCalendarScreen extends StatelessWidget {
  const LunarCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lunar Sync'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const LunarCycleCard(
              phase: 0.62,
              phaseName: 'Waxing Gibbous',
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: NivoraPalette.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: NivoraPalette.edge),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.bedtime_outlined, color: NivoraPalette.accent),
                      SizedBox(width: 8),
                      Text(
                        'Circadian Moonlight Note',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: NivoraPalette.ink),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'During the Waxing Gibbous phase, nighttime ambient luminescence increases. Consider closing heavy blackout curtains to avoid micro-arousals during deep NREM sleep.',
                    style: TextStyle(fontSize: 13, color: NivoraPalette.inkMuted, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: NivoraPalette.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: NivoraPalette.edge),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Upcoming Moon Phases',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: NivoraPalette.ink),
                  ),
                  const SizedBox(height: 12),
                  _phaseRow('Full Moon', 'In 4 days', 'Peak nocturnal arousal window'),
                  const Divider(color: NivoraPalette.edge),
                  _phaseRow('Waning Gibbous', 'In 11 days', 'Deeper restorative N3 delta waves'),
                  const Divider(color: NivoraPalette.edge),
                  _phaseRow('New Moon', 'In 18 days', 'Optimal natural sleep onset environment'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _phaseRow(String name, String days, String effect) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: NivoraPalette.ink)),
              Text(effect, style: const TextStyle(fontSize: 12, color: NivoraPalette.inkMuted)),
            ],
          ),
          Text(days, style: const TextStyle(fontSize: 13, color: NivoraPalette.accent)),
        ],
      ),
    );
  }
}
