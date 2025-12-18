import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CounterModel extends ChangeNotifier {
  int _counter = 0;

  int get counter => _counter;

  CounterModel() {
    _loadCounter();
  }

  Future<void> _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('counter') ?? 0;
    notifyListeners();
  }

  Future<void> increment() async {
    _counter++;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('counter', _counter);
  }

  Future<void> decrement() async {
    _counter--;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('counter', _counter);
  }

  Future<void> reset() async {
    _counter = 0;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('counter', _counter);
  }
}
