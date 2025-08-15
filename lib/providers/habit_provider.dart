import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit.dart';

class HabitProvider with ChangeNotifier {
  List<Habit> _habits = [];

  List<Habit> get habits => _habits;

  /// Load saved habits from SharedPreferences
  Future<void> loadHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('habits');

    if (data != null) {
      List decoded = jsonDecode(data);
      _habits = decoded.map((h) => Habit.fromMap(h)).toList();
    }
    notifyListeners();
  }

  /// Save habits to local storage
  Future<void> saveHabits() async {
    final prefs = await SharedPreferences.getInstance();
    String data = jsonEncode(_habits.map((h) => h.toMap()).toList());
    await prefs.setString('habits', data);
  }

  /// Add a new habit
  void addHabit(Habit habit) {
    _habits.add(habit);
    saveHabits();
    notifyListeners();
  }

  void deleteHabit(String id) {
    _habits.removeWhere((habit) => habit.id == id);
    saveHabits();
    notifyListeners();
  }

  void updateHabit(Habit updatedHabit) {
    final index = _habits.indexWhere((h) => h.id == updatedHabit.id);
    if (index != -1) {
      _habits[index] = updatedHabit;
      saveHabits();
      notifyListeners();
    }
  }

  /// Toggle completion for today
  void toggleHabitCompletion(String id) {
    final habit = _habits.firstWhere((h) => h.id == id);
    final today = DateTime.now();

    bool isSameDay(DateTime date1, DateTime date2) =>
        date1.day == date2.day &&
        date1.month == date2.month &&
        date1.year == date2.year;

    if (habit.lastCompletedDate != null &&
        isSameDay(habit.lastCompletedDate!, today)) {
      // Undo completion
      habit.lastCompletedDate = null;
      habit.currentStreak =
          (habit.currentStreak > 0) ? habit.currentStreak - 1 : 0;
    } else {
      // Mark complete
      if (habit.lastCompletedDate != null &&
          isSameDay(habit.lastCompletedDate!,
              today.subtract(const Duration(days: 1)))) {
        habit.currentStreak++;
      } else {
        habit.currentStreak = 1;
      }
      if (habit.currentStreak > habit.bestStreak) {
        habit.bestStreak = habit.currentStreak;
      }
      habit.lastCompletedDate = today;
    }

    saveHabits();
    notifyListeners();
  }
}
