import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../models/habit.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);

    // Sort habits by best streak (descending)
    final List<Habit> sortedHabits = List.from(habitProvider.habits);
    sortedHabits.sort((a, b) => b.bestStreak.compareTo(a.bestStreak));

    return Scaffold(
      appBar: AppBar(
        title: const Text("🏆 Leaderboard"),
        backgroundColor: Colors.teal,
      ),
      body: sortedHabits.isEmpty
          ? const Center(
              child: Text(
                "No habits yet.\nAdd habits to see rankings!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: sortedHabits.length,
              itemBuilder: (context, index) {
                final habit = sortedHabits[index];

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(
                        int.parse(habit.color.replaceFirst('#', '0xff')),
                      ),
                      child: Icon(
                        IconData(
                          int.tryParse(habit.iconPath) ?? Icons.check.codePoint,
                          fontFamily: 'MaterialIcons',
                        ),
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      habit.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("🔥 Best Streak: ${habit.bestStreak} days"),
                    trailing: Text(
                      "#${index + 1}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: index == 0 ? Colors.amber.shade700 : Colors.grey,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
