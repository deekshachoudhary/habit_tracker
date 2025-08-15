import 'package:flutter/material.dart';
import 'package:habit_tracker/screens/leaderboard_screen.dart';
import 'package:provider/provider.dart';
import 'providers/habit_provider.dart';
import 'screens/habit_list_screen.dart';
import 'screens/add_habit_screen.dart';
import 'utils/theme.dart';
import 'screens/habit_detail_screen.dart';
import 'screens/edit_habit_screen.dart';
import 'models/habit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (_) => HabitProvider()..loadHabits(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const HabitListScreen(),
      routes: {
        '/add-habit': (context) => const AddHabitScreen(),
        '/habit-detail': (context) => const HabitDetailScreen(),
        '/edit-habit': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Habit;
          return EditHabitScreen(habit: args);
        },
        '/leaderboard': (context) => const LeaderboardScreen(),
      },
    );
  }
}
