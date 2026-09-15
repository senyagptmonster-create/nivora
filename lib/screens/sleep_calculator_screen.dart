import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/sleep_cycle_service.dart';
import '../theme/nivora_theme.dart';

class SleepCalculatorScreen extends StatefulWidget {
  const SleepCalculatorScreen({super.key});

  @override
  State<SleepCalculatorScreen> createState() => _SleepCalculatorScreenState();
}

class _SleepCalculatorScreenState extends State<SleepCalculatorScreen> {
  bool _calcWakeTimes = true;
  TimeOfDay _selectedTime = const TimeOfDay(hour: 22, minute: 30);

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = context.watch<SleepCycleService>();
    final options = _calcWakeTimes
        ? service.calculateWakeTimes(_selectedTime)
        : service.calculateBedTimes(_selectedTime);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nivora Sleep Cycles'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: NivoraPalette.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: NivoraPalette.edge),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Center(child: Text('I want to wake at')),
                      selected: !_calcWakeTimes,
                      selectedColor: NivoraPalette.accent,
                      labelStyle: TextStyle(
                        color: !_calcWakeTimes ? Colors.white : NivoraPalette.inkMuted,
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (val) => setState(() => _calcWakeTimes = false),
                    ),
                  ),
                  Expanded(
                    child: ChoiceChip(
                      label: const Center(child: Text('I go to bed at')),
                      selected: _calcWakeTimes,
                      selectedColor: NivoraPalette.accent,
                      labelStyle: TextStyle(
                        color: _calcWakeTimes ? Colors.white : NivoraPalette.inkMuted,
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (val) => setState(() => _calcWakeTimes = true),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _pickTime,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: NivoraPalette.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: NivoraPalette.edge),
                ),
                child: Column(
                  children: [
                    Text(
                      _calcWakeTimes ? 'Target Bedtime' : 'Target Wake-Up Time',
                      style: const TextStyle(fontSize: 13, color: NivoraPalette.inkMuted),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _selectedTime.format(context),
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: NivoraPalette.accent,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Tap to change time',
                      style: TextStyle(fontSize: 12, color: NivoraPalette.accent2),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _calcWakeTimes ? 'Recommended Wake Times' : 'Recommended Bedtimes',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: NivoraPalette.ink),
            ),
            const SizedBox(height: 6),
            const Text(
              'A standard human sleep cycle lasts approximately 90 minutes.',
              style: TextStyle(fontSize: 13, color: NivoraPalette.inkMuted),
            ),
            const SizedBox(height: 14),
            ...options.map((opt) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: opt.isOptimal
                      ? NivoraPalette.accent.withAlpha(25)
                      : NivoraPalette.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: opt.isOptimal ? NivoraPalette.accent : NivoraPalette.edge,
                    width: opt.isOptimal ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          opt.time.format(context),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: opt.isOptimal ? NivoraPalette.accent2 : NivoraPalette.ink,
                          ),
                        ),
                        Text(
                          '${opt.hours.toStringAsFixed(1)} hours of rest',
                          style: const TextStyle(fontSize: 12, color: NivoraPalette.inkMuted),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: opt.isOptimal ? NivoraPalette.accent : NivoraPalette.edge,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${opt.cycleCount} Cycles ${opt.isOptimal ? "★ Optimal" : ""}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: opt.isOptimal ? Colors.white : NivoraPalette.ink,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
