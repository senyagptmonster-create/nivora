import 'package:flutter/material.dart';
import '../app/brand.dart';

class NivoraHome extends StatefulWidget {
  const NivoraHome({super.key});
  @override
  State<NivoraHome> createState() => _NivoraHomeState();
}

class _NivoraHomeState extends State<NivoraHome> {
  int _currentIndex = 0;
  final List<Widget> _screens = const [
    CalculatorScreen(),
    SoundsScreen(),
    ScheduleScreen(),
    TipsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: cAccent,
        unselectedItemColor: cInk.withValues(alpha: 0.5),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'Calc'),
          BottomNavigationBarItem(icon: Icon(Icons.music_note), label: 'Sounds'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Schedule'),
          BottomNavigationBarItem(icon: Icon(Icons.lightbulb), label: 'Tips'),
        ],
      ),
    );
  }
}

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculator')),
      body: const Center(child: Text('90-min Cycle Calculator')),
    );
  }
}

class SoundsScreen extends StatelessWidget {
  const SoundsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wind-down Sounds')),
      body: const Center(child: Text('Sounds List')),
    );
  }
}

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Schedule Log')),
      body: const Center(child: Text('Sleep Log')),
    );
  }
}

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rest Tips')),
      body: const Center(child: Text('Tips List')),
    );
  }
}
