import 'package:flutter/material.dart';
import 'package:todoapp/features/toDoListApp/presentation/screens/add_task.dart';
import 'package:todoapp/features/toDoListApp/presentation/screens/completed_tasks_screen.dart';
import 'package:todoapp/features/toDoListApp/presentation/screens/task_list_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String tasks = '/tasks';
  static const String completedtasks = '/completedtasks';
  static const String calendar = '/calendar';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> routes = {
    home: (context) => const TaskListScreen(),
    completedtasks: (context) => const CompletedTasksScreen(),
    // tasks: (context) => const TaskScreen(),
    // calendar: (context) => const CalendarScreen(),
    // settings: (context) => const SettingsScreen(),
    // profile: (context) => const ProfileScreen(),
  };
}
