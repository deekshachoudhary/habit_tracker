import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/habit_provider.dart';
import '../widgets/animated_feedback.dart';
import '../models/habit.dart';

class HabitListScreen extends StatefulWidget {
  const HabitListScreen({super.key});

  @override
  State<HabitListScreen> createState() => _HabitListScreenState();
}

class _HabitListScreenState extends State<HabitListScreen> {
  bool _showConfetti = false; // controls animation trigger

  String _greetingMessage() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning ☀️";
    if (hour < 17) return "Good Afternoon 🌤";
    return "Good Evening 🌙";
  }

  void _triggerConfetti() {
    setState(() {
      _showConfetti = !_showConfetti;
    });
  }

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Habit Tracker"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.leaderboard),
            tooltip: "View Leaderboard",
            onPressed: () {
              Navigator.pushNamed(context, '/leaderboard');
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _greetingMessage(),
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Keep going, you're doing great! 💪",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),

                // Weekly Summary Banner - Gradient
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.teal, Colors.green],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.teal.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.star, color: Colors.white),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Weekly Streak: You kept up 4 habits this week! 🎯",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Habit List
                Expanded(
                  child: habitProvider.habits.isEmpty
                      ? const Center(
                          child: Text(
                            "No habits yet.\nTap + to add one.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: habitProvider.habits.length,
                          itemBuilder: (ctx, index) {
                            final habit = habitProvider.habits[index];

                            bool isDoneToday =
                                habit.lastCompletedDate != null &&
                                    habit.lastCompletedDate!.day ==
                                        DateTime.now().day &&
                                    habit.lastCompletedDate!.month ==
                                        DateTime.now().month &&
                                    habit.lastCompletedDate!.year ==
                                        DateTime.now().year;

                            double progress = (habit.currentStreak /
                                (habit.bestStreak == 0 ? 1 : habit.bestStreak));
                            if (habit.bestStreak == 0) progress = 0;

                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/habit-detail',
                                  arguments: habit,
                                );
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 4,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Row(
                                    children: [
                                      // Colored icon circle
                                      CircleAvatar(
                                        radius: 24,
                                        backgroundColor: Color(int.parse(habit
                                            .color
                                            .replaceFirst('#', '0xff'))),
                                        child: Icon(
                                          IconData(
                                            int.tryParse(habit.iconPath) ??
                                                Icons.check.codePoint,
                                            fontFamily: 'MaterialIcons',
                                          ),
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 16),

                                      // Name & Streak info
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              habit.title,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "🔥 ${habit.currentStreak} days  |  🏆 Best: ${habit.bestStreak}",
                                              style:
                                                  const TextStyle(fontSize: 13),
                                            ),
                                            const SizedBox(height: 6),
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: LinearProgressIndicator(
                                                value: progress.isNaN
                                                    ? 0
                                                    : progress.clamp(0, 1),
                                                backgroundColor:
                                                    Colors.grey.shade200,
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                        progress > 0.7
                                                            ? Colors.amber
                                                            : Colors.teal),
                                                minHeight: 6,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Mark as Done Button
                                      IconButton(
                                        icon: Icon(
                                          isDoneToday
                                              ? Icons.check_circle
                                              : Icons.radio_button_unchecked,
                                          size: 28,
                                          color: isDoneToday
                                              ? Colors.green
                                              : Colors.grey,
                                        ),
                                        onPressed: () {
                                          habitProvider
                                              .toggleHabitCompletion(habit.id);

                                          // Trigger confetti only when marking done
                                          if (!isDoneToday) {
                                            _triggerConfetti();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),

          // Confetti overlay
          Align(
            alignment: Alignment.topCenter,
            child: AnimatedFeedback(trigger: _showConfetti),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          Navigator.pushNamed(context, '/add-habit');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
