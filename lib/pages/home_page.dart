import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/habit_provider.dart';
import 'habit_details_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);
    final today = DateTime.now();
    final String formattedDate = DateFormat.yMMMMd().format(today);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Habit Tracker',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              formattedDate,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: habitProvider.habits.isEmpty
          ? const Center(
              child: Text(
                'No habits added yet. Let\'s get started!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: habitProvider.habits.length,
              itemBuilder: (context, index) {
                final habit = habitProvider.habits[index];
                final isCompletedToday = habit.isCompletedOn(today);

                return Card(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    leading: GestureDetector(
                      onTap: () {
                        habitProvider.toggleHabitCompletion(habit.id, today);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCompletedToday
                              ? Colors.green
                              : Colors.grey[200],
                        ),
                        child: Icon(
                          Icons.check,
                          color: isCompletedToday
                              ? Colors.white
                              : Colors.grey[400],
                        ),
                      ),
                    ),
                    title: Text(
                      habit.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        decoration:
                            isCompletedToday ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: Text(
                      habit.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => 
                                HabitDetailsPage(habitId: habit.id),
                          ),
                        );
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => 
                              HabitDetailsPage(habitId: habit.id),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
