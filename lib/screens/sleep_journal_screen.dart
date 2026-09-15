import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/sleep_cycle_service.dart';
import '../theme/nivora_theme.dart';

class SleepJournalScreen extends StatelessWidget {
  const SleepJournalScreen({super.key});

  void _showAddEntry(BuildContext context) {
    TimeOfDay bedTime = const TimeOfDay(hour: 23, minute: 0);
    TimeOfDay wakeTime = const TimeOfDay(hour: 7, minute: 0);
    int rating = 4;
    final noteCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: NivoraPalette.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Log Rest Session',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: NivoraPalette.ink),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: NivoraPalette.edge),
                        icon: const Icon(Icons.nightlight_round, size: 16),
                        label: Text('Bed: ${bedTime.format(context)}'),
                        onPressed: () async {
                          final p = await showTimePicker(context: context, initialTime: bedTime);
                          if (p != null) setModalState(() => bedTime = p);
                        },
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: NivoraPalette.edge),
                        icon: const Icon(Icons.wb_sunny_outlined, size: 16),
                        label: Text('Wake: ${wakeTime.format(context)}'),
                        onPressed: () async {
                          final p = await showTimePicker(context: context, initialTime: wakeTime);
                          if (p != null) setModalState(() => wakeTime = p);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Quality Rating (1 to 5 Stars)', style: TextStyle(fontSize: 13, color: NivoraPalette.inkMuted)),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (i) {
                      final star = i + 1;
                      return IconButton(
                        icon: Icon(
                          star <= rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () => setModalState(() => rating = star),
                      );
                    }),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: noteCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Notes on dreams, morning energy, coffee...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: NivoraPalette.accent,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        context.read<SleepCycleService>().addJournalRecord(
                          bedTime,
                          wakeTime,
                          rating,
                          noteCtrl.text.trim(),
                        );
                        Navigator.pop(ctx);
                      },
                      child: const Text('Save Journal Entry'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = context.watch<SleepCycleService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sleep Journal'),
      ),
      body: service.records.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.menu_book_outlined, size: 64, color: NivoraPalette.inkMuted.withAlpha(100)),
                  const SizedBox(height: 12),
                  const Text('No sleep logs recorded yet', style: TextStyle(color: NivoraPalette.inkMuted)),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: service.records.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, idx) {
                final rec = service.records[idx];
                return Container(
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
                          Text(
                            '${rec.date.month}/${rec.date.day}/${rec.date.year}',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: NivoraPalette.accent2),
                          ),
                          Row(
                            children: List.generate(
                              rec.qualityRating,
                              (_) => const Icon(Icons.star, size: 16, color: Colors.amber),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Bed: ${rec.bedTime.format(context)}  →  Wake: ${rec.wakeTime.format(context)}',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: NivoraPalette.ink),
                      ),
                      if (rec.notes.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          rec.notes,
                          style: const TextStyle(fontSize: 13, color: NivoraPalette.inkMuted),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: NivoraPalette.accent,
        foregroundColor: Colors.white,
        onPressed: () => _showAddEntry(context),
        icon: const Icon(Icons.add),
        label: const Text('Log Rest'),
      ),
    );
  }
}
