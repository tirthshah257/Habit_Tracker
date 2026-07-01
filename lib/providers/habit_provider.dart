import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/habit.dart';

class HabitProvider extends ChangeNotifier {
  List<Habit> _habits = [];
  final String _prefsKey = 'habit_tracker_data';

  List<Habit> get habits => _habits;

  HabitProvider() {
    loadHabits();
  }

  // Load habits from SharedPreferences
  Future<void> loadHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_prefsKey);

    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      _habits = jsonList.map((json) => Habit.fromJson(json)).toList();
      notifyListeners();
    }
  }

  // Save the current state to SharedPreferences
  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _habits.map((habit) => habit.toJson()).toList();
    await prefs.setString(_prefsKey, jsonEncode(jsonList));
  }

  // Add a new habit
  void addHabit(String name, String description) {
    final newHabit = Habit(
      id: const Uuid().v4(),
      name: name,
      description: description,
    );
    _habits.add(newHabit);
    _saveToPrefs();
    notifyListeners();
  }

  // Delete a habit
  void deleteHabit(String id) {
    _habits.removeWhere((habit) => habit.id == id);
    _saveToPrefs();
    notifyListeners();
  }

  // Toggle habit completion for a specific date
  void toggleHabitCompletion(String id, DateTime date) {
    final index = _habits.indexWhere((habit) => habit.id == id);
    if (index != -1) {
      final habit = _habits[index];
      
      // Normalize the date to ignore time component
      final day = DateTime(date.year, date.month, date.day);
      
      final isCompleted = habit.completedDates.any((d) => 
        d.year == day.year && d.month == day.month && d.day == day.day);

      if (isCompleted) {
        // Remove the date
        habit.completedDates.removeWhere((d) => 
          d.year == day.year && d.month == day.month && d.day == day.day);
      } else {
        // Add the date
        habit.completedDates.add(day);
      }

      _saveToPrefs();
      notifyListeners();
    }
  }
}
