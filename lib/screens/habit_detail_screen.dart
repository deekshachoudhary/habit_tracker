import 'package:flutter/material.dart';
import '../models/habit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';

class HabitDetailScreen extends StatelessWidget {
  const HabitDetailScreen({super.key});

  List<DateTime> _getLast7Days() {
    final today = DateTime.now();
    return List.generate(7, (index) => today.subtract(Duration(days: index)))
        .reversed
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final Habit habit = ModalRoute.of(context)!.settings.arguments as Habit;
    final last7Days = _getLast7Days();

    // MediaQuery values for responsiveness
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // Top colored banner: similar to main screen card
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
                top: sh * 0.08,
                bottom: sh * 0.03,
                left: sw * 0.05,
                right: sw * 0.05),
            decoration: BoxDecoration(
              color: Color(int.parse(habit.color.replaceFirst('#', '0xff'))),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(sw * 0.06),
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.teal.withOpacity(0.09),
                    blurRadius: sw * 0.03,
                    offset: Offset(0, sh * 0.005))
              ],
            ),
            child: Column(
              children: [
                // Icon
                CircleAvatar(
                  radius: sw * 0.075,
                  backgroundColor: Colors.white,
                  child: Icon(
                    IconData(
                        int.tryParse(habit.iconPath) ?? Icons.check.codePoint,
                        fontFamily: 'MaterialIcons'),
                    color:
                        Color(int.parse(habit.color.replaceFirst('#', '0xff'))),
                    size: sw * 0.07,
                  ),
                ),
                SizedBox(height: sh * 0.01),
                // Title
                Text(
                  habit.title,
                  style: TextStyle(
                    fontSize: sw * 0.065,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: sh * 0.008),
                // Subtitle
                Text(
                  "Your habit journey 💪",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: sw * 0.044,
                  ),
                ),
                SizedBox(height: sh * 0.027),
                // Streak badges
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _streakBadge(
                      icon: Icons.local_fire_department,
                      label: "Current Streak",
                      value: habit.currentStreak.toString(),
                      sw: sw,
                      sh: sh,
                    ),
                    SizedBox(width: sw * 0.07),
                    _streakBadge(
                      icon: Icons.emoji_events,
                      label: "Best Streak",
                      value: habit.bestStreak.toString(),
                      sw: sw,
                      sh: sh,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: sh * 0.03),

          // Weekly history text
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sw * 0.06),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Past 7 Days",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: sw * 0.055,
                    ),
              ),
            ),
          ),
          SizedBox(height: sh * 0.012),

          // Weekly history days boxes
          SizedBox(
            height: sh * 0.10,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: last7Days.length,
              itemBuilder: (context, index) {
                final date = last7Days[index];
                final isCompleted = habit.lastCompletedDate != null &&
                    habit.lastCompletedDate!.day == date.day &&
                    habit.lastCompletedDate!.month == date.month &&
                    habit.lastCompletedDate!.year == date.year;
                return Container(
                  width: sw * 0.14,
                  margin: EdgeInsets.symmetric(horizontal: sw * 0.018),
                  decoration: BoxDecoration(
                    color: isCompleted ? Colors.teal : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(sw * 0.038),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('E').format(date),
                        style: TextStyle(
                          color:
                              isCompleted ? Colors.white : Colors.grey.shade800,
                          fontWeight: FontWeight.bold,
                          fontSize: sw * 0.040,
                        ),
                      ),
                      SizedBox(height: sh * 0.006),
                      Icon(
                        isCompleted ? Icons.check_circle : Icons.cancel,
                        color:
                            isCompleted ? Colors.white : Colors.grey.shade600,
                        size: sw * 0.063,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          SizedBox(height: sh * 0.03),

          // Action buttons
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sw * 0.06),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA7FBF3),
                      foregroundColor: Colors.teal, // icon/text color
                      padding: EdgeInsets.symmetric(
                          vertical: sh * 0.017, horizontal: sw * 0.01),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(sw * 0.04),
                      ),
                      textStyle: TextStyle(fontSize: sw * 0.046),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/edit-habit',
                        arguments: habit,
                      );
                    },
                    icon: Icon(Icons.edit, size: sw * 0.06),
                    label: Text("Edit"),
                  ),
                ),
                SizedBox(width: sw * 0.03),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF58F8D),
                      foregroundColor: Colors.white, // icon/text color
                      padding: EdgeInsets.symmetric(
                          vertical: sh * 0.017, horizontal: sw * 0.01),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(sw * 0.04),
                      ),
                      textStyle: TextStyle(fontSize: sw * 0.046),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text("Delete Habit"),
                          content: const Text(
                              "Are you sure you want to delete this habit? This action cannot be undone."),
                          actions: [
                            TextButton(
                              child: const Text("Cancel"),
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF58F8D),
                              ),
                              onPressed: () {
                                Provider.of<HabitProvider>(context,
                                        listen: false)
                                    .deleteHabit(habit.id);
                                Navigator.of(ctx).pop();
                                Navigator.of(context).pop();
                              },
                              child: const Text("Delete"),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: Icon(Icons.delete, size: sw * 0.06),
                    label: Text("Delete"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _streakBadge({
    required IconData icon,
    required String label,
    required String value,
    required double sw,
    required double sh,
  }) {
    return Column(
      children: [
        CircleAvatar(
          radius: sw * 0.062,
          backgroundColor: Colors.white,
          child: Icon(icon, color: Color(0xFFF0AB43), size: sw * 0.055),
        ),
        SizedBox(height: sh * 0.007),
        Text(
          "$value days",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: sw * 0.040,
              color: Colors.white),
        ),
        Text(
          label,
          style: TextStyle(fontSize: sw * 0.03, color: Colors.white70),
        ),
      ],
    );
  }
}
