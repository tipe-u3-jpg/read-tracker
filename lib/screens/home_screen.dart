/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'counter_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final counterModel = context.watch<CounterModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Home / Reading Tracker')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Прочитано сторінок:'),
            Text(
              '${counterModel.counter}',
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: counterModel.increment,
                  child: const Text('+'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: counterModel.decrement,
                  child: const Text('-'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: counterModel.reset,
                  child: const Text('Скинути'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
*/


import 'package:flutter/material.dart';
import 'books_screen.dart';
import 'statistics_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _tabs = const [
    BooksTab(),
    StatisticsTab(),
    ProfileTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF4F92FF),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.book), label: 'Книжки'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: 'Статистика'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'Профіль'),
        ],
      ),
    );
  }
}
