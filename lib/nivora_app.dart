import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/sleep_cycle_service.dart';
import 'theme/nivora_theme.dart';
import 'screens/sleep_calculator_screen.dart';
import 'screens/lunar_calendar_screen.dart';
import 'screens/sleep_journal_screen.dart';
import 'screens/rest_settings_screen.dart';

class NivoraApp extends StatelessWidget {
  const NivoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SleepCycleService(),
      child: MaterialApp(
        title: 'Nivora Lunar Rest',
        debugShowCheckedModeBanner: false,
        theme: NivoraPalette.theme,
        home: const _NivoraShell(),
      ),
    );
  }
}

class _NivoraShell extends StatelessWidget {
  const _NivoraShell();

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 4,
      child: Scaffold(
        body: TabBarView(
          children: [
            SleepCalculatorScreen(),
            LunarCalendarScreen(),
            SleepJournalScreen(),
            RestSettingsScreen(),
          ],
        ),
        bottomNavigationBar: Material(
          color: NivoraPalette.surface,
          child: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.alarm_on_outlined), text: 'Cycles'),
              Tab(icon: Icon(Icons.nightlight_round_outlined), text: 'Lunar'),
              Tab(icon: Icon(Icons.menu_book_outlined), text: 'Journal'),
              Tab(icon: Icon(Icons.settings_outlined), text: 'Settings'),
            ],
          ),
        ),
      ),
    );
  }
}
