import 'package:flutter/material.dart';
import 'ui/nivora_theme.dart';
import 'ui/moon_phase_painter.dart';

class NivoraApp extends StatefulWidget {
  const NivoraApp({super.key});

  @override
  State<NivoraApp> createState() => _NivoraAppState();
}

class _NivoraAppState extends State<NivoraApp> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  TimeOfDay _wakeTime = const TimeOfDay(hour: 7, minute: 0);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nivora Sleep Lunar',
      debugShowCheckedModeBanner: false,
      theme: NivoraTheme.theme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Nivora Circadian Flow', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (idx) => setState(() => _currentPage = idx),
                children: [
                  _CycleCalculatorPage(
                    wakeTime: _wakeTime,
                    onPickTime: (t) => setState(() => _wakeTime = t),
                  ),
                  const _DeficitTrackerPage(),
                  const _LunarPhasePage(),
                  const _SleepHygienePage(),
                ],
              ),
            ),
            // Dot PageIndicator at bottom
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  final isSel = _currentPage == index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isSel ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isSel ? NivoraTheme.moonGlow : Colors.grey.shade700,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CycleCalculatorPage extends StatelessWidget {
  final TimeOfDay wakeTime;
  final ValueChanged<TimeOfDay> onPickTime;

  const _CycleCalculatorPage({required this.wakeTime, required this.onPickTime});

  @override
  Widget build(BuildContext context) {
    final bedTimes = [
      {'cycles': 6, 'hours': '9.0 hrs', 'time': _calcBedTime(wakeTime, 6 * 90)},
      {'cycles': 5, 'hours': '7.5 hrs (Optimal)', 'time': _calcBedTime(wakeTime, 5 * 90)},
      {'cycles': 4, 'hours': '6.0 hrs', 'time': _calcBedTime(wakeTime, 4 * 90)},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: NivoraTheme.cardSurface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Text('Wake Up Target Time', style: TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 6),
                Text(wakeTime.format(context),
                    style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: NivoraTheme.moonGlow)),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () async {
                    final picked = await showTimePicker(context: context, initialTime: wakeTime);
                    if (picked != null) onPickTime(picked);
                  },
                  icon: const Icon(Icons.edit_calendar),
                  label: const Text('Adjust Alarm'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Recommended Sleep Cycles (90 min)', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...bedTimes.map((b) => Card(
                color: NivoraTheme.cardSurface,
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: ListTile(
                  leading: const Icon(Icons.nightlight, color: NivoraTheme.moonGlow),
                  title: Text(b['time'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  subtitle: Text(b['hours'] as String),
                  trailing: Text('${b['cycles']} Cycles', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                ),
              )),
        ],
      ),
    );
  }

  String _calcBedTime(TimeOfDay wake, int minutesBefore) {
    int totalWakeMins = wake.hour * 60 + wake.minute;
    int bedMins = (totalWakeMins - minutesBefore - 15) % (24 * 60); // 15 min to fall asleep
    if (bedMins < 0) bedMins += 24 * 60;
    final h = (bedMins ~/ 60).toString().padLeft(2, '0');
    final m = (bedMins % 60).toString().padLeft(2, '0');
    return '$h:$m';
  }
}

class _DeficitTrackerPage extends StatelessWidget {
  const _DeficitTrackerPage();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: NivoraTheme.cardSurface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: const [
                Text('Cumulative Sleep Debt', style: TextStyle(color: Colors.grey)),
                SizedBox(height: 8),
                Text('-1.2 Hours', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Color(0xFFFFB703))),
                SizedBox(height: 6),
                Text('You averaged 7.1h vs 7.5h target this week', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LunarPhasePage extends StatelessWidget {
  const _LunarPhasePage();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          SizedBox(
            width: 180,
            height: 180,
            child: CustomPaint(
              painter: MoonPhasePainter(illumination: 0.78),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Waxing Gibbous Moon (78%)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: NivoraTheme.moonGlow)),
          const SizedBox(height: 8),
          const Text(
            'Melatonin secretion naturally drops slightly leading up to full moons. Lower bedroom ambient light accordingly.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, height: 1.4, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _SleepHygienePage extends StatelessWidget {
  const _SleepHygienePage();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: const [
        Text('Circadian Principles', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        SizedBox(height: 12),
        ListTile(
          leading: Icon(Icons.wb_sunny, color: Colors.amber),
          title: Text('Morning Sunlight Anchor'),
          subtitle: Text('Get 10-15 min of direct sunlight within 30 min of waking to set master clock.'),
        ),
        ListTile(
          leading: Icon(Icons.thermostat, color: Colors.cyan),
          title: Text('Core Temperature Drop'),
          subtitle: Text('Bedroom temperature around 18°C (65°F) triggers natural sleep induction.'),
        ),
      ],
    );
  }
}
