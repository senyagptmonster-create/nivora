import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/sleep_cycle_service.dart';
import '../theme/nivora_theme.dart';

class RestSettingsScreen extends StatelessWidget {
  const RestSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = context.watch<SleepCycleService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rest Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: NivoraPalette.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: NivoraPalette.edge),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Daily Sleep Goal',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: NivoraPalette.ink),
                    ),
                    Text(
                      '${service.sleepGoalHours.toStringAsFixed(1)} hours',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: NivoraPalette.accent),
                    ),
                  ],
                ),
                Slider(
                  value: service.sleepGoalHours,
                  min: 6.0,
                  max: 10.0,
                  divisions: 8,
                  activeColor: NivoraPalette.accent,
                  onChanged: (val) => service.setSleepGoal(val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: NivoraPalette.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: NivoraPalette.edge),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'About Nivora Sleep',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: NivoraPalette.ink),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Nivora optimizes waking intervals based on the ultradian 90-minute sleep cycle rhythm. Waking at the end of a cycle eliminates grogginess (sleep inertia).',
                  style: TextStyle(fontSize: 13, color: NivoraPalette.inkMuted, height: 1.4),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent.withAlpha(40),
                    foregroundColor: Colors.redAccent,
                  ),
                  onPressed: () => service.clearAll(),
                  child: const Text('Reset All Sleep Records'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
