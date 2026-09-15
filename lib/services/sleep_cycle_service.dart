import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JournalRecord {
  final String id;
  final DateTime date;
  final TimeOfDay bedTime;
  final TimeOfDay wakeTime;
  final int qualityRating;
  final String notes;

  JournalRecord({
    required this.id,
    required this.date,
    required this.bedTime,
    required this.wakeTime,
    required this.qualityRating,
    required this.notes,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'bedHour': bedTime.hour,
    'bedMin': bedTime.minute,
    'wakeHour': wakeTime.hour,
    'wakeMin': wakeTime.minute,
    'qualityRating': qualityRating,
    'notes': notes,
  };

  factory JournalRecord.fromJson(Map<String, dynamic> m) => JournalRecord(
    id: m['id'] as String,
    date: DateTime.parse(m['date'] as String),
    bedTime: TimeOfDay(hour: m['bedHour'] as int, minute: m['bedMin'] as int),
    wakeTime: TimeOfDay(hour: m['wakeHour'] as int, minute: m['wakeMin'] as int),
    qualityRating: m['qualityRating'] as int,
    notes: m['notes'] as String,
  );
}

class SleepCycleOption {
  final int cycleCount;
  final TimeOfDay time;
  final double hours;
  final bool isOptimal;

  SleepCycleOption({
    required this.cycleCount,
    required this.time,
    required this.hours,
    required this.isOptimal,
  });
}

class SleepCycleService extends ChangeNotifier {
  static const _journalKey = 'nivora_journal_v2';
  static const _goalKey = 'nivora_sleep_goal_v2';

  final List<JournalRecord> _records = [];
  double _sleepGoalHours = 8.0;

  List<JournalRecord> get records => List.unmodifiable(_records);
  double get sleepGoalHours => _sleepGoalHours;

  SleepCycleService() {
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    _sleepGoalHours = prefs.getDouble(_goalKey) ?? 8.0;

    final raw = prefs.getString(_journalKey);
    if (raw != null) {
      final List dec = jsonDecode(raw);
      _records.clear();
      _records.addAll(dec.map((e) => JournalRecord.fromJson(e)));
    } else {
      _records.addAll([
        JournalRecord(
          id: '1',
          date: DateTime.now().subtract(const Duration(days: 1)),
          bedTime: const TimeOfDay(hour: 23, minute: 0),
          wakeTime: const TimeOfDay(hour: 7, minute: 0),
          qualityRating: 5,
          notes: 'Felt refreshed and light upon waking.',
        ),
        JournalRecord(
          id: '2',
          date: DateTime.now().subtract(const Duration(days: 2)),
          bedTime: const TimeOfDay(hour: 0, minute: 30),
          wakeTime: const TimeOfDay(hour: 6, minute: 30),
          qualityRating: 4,
          notes: 'Deep REM phase during second half.',
        ),
      ]);
    }
    notifyListeners();
  }

  Future<void> setSleepGoal(double hours) async {
    _sleepGoalHours = hours;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_goalKey, hours);
    notifyListeners();
  }

  Future<void> addJournalRecord(TimeOfDay bed, TimeOfDay wake, int rating, String notes) async {
    final rec = JournalRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      bedTime: bed,
      wakeTime: wake,
      qualityRating: rating,
      notes: notes,
    );
    _records.insert(0, rec);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_journalKey, jsonEncode(_records.map((e) => e.toJson()).toList()));
    notifyListeners();
  }

  Future<void> deleteJournalRecord(String id) async {
    _records.removeWhere((r) => r.id == id);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_journalKey, jsonEncode(_records.map((e) => e.toJson()).toList()));
    notifyListeners();
  }

  Future<void> clearAll() async {
    _records.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_journalKey);
    notifyListeners();
  }

  List<SleepCycleOption> calculateWakeTimes(TimeOfDay bedtime) {
    final now = DateTime.now();
    final base = DateTime(now.year, now.month, now.day, bedtime.hour, bedtime.minute)
        .add(const Duration(minutes: 15)); // 15 min latency to fall asleep

    return [3, 4, 5, 6].map((c) {
      final t = base.add(Duration(minutes: c * 90));
      return SleepCycleOption(
        cycleCount: c,
        time: TimeOfDay(hour: t.hour, minute: t.minute),
        hours: (c * 90) / 60.0,
        isOptimal: c == 5 || c == 6,
      );
    }).toList();
  }

  List<SleepCycleOption> calculateBedTimes(TimeOfDay wakeTime) {
    final now = DateTime.now();
    final base = DateTime(now.year, now.month, now.day, wakeTime.hour, wakeTime.minute);

    return [6, 5, 4, 3].map((c) {
      final t = base.subtract(Duration(minutes: c * 90 + 15));
      return SleepCycleOption(
        cycleCount: c,
        time: TimeOfDay(hour: t.hour, minute: t.minute),
        hours: (c * 90) / 60.0,
        isOptimal: c == 5 || c == 6,
      );
    }).toList();
  }
}
