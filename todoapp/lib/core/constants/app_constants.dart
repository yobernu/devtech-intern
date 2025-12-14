import 'package:flutter/material.dart';

class AppConstants {
  // Categories
  static const String categoryWork = 'Work';
  static const String categoryPersonal = 'Personal';
  static const String categoryShopping = 'Shopping';
  static const String categoryHealth = 'Health';
  static const String categoryEducation = 'Education';
  static const String categoryFinance = 'Finance';
  static const String categoryOther = 'Other';

  static const List<String> categories = [
    categoryWork,
    categoryPersonal,
    categoryShopping,
    categoryHealth,
    categoryEducation,
    categoryFinance,
    categoryOther,
  ];

  static Map<String, IconData> categoryIcons = {
    categoryWork: Icons.work_outline,
    categoryPersonal: Icons.person_outline,
    categoryShopping: Icons.shopping_cart_outlined,
    categoryHealth: Icons.fitness_center_outlined,
    categoryEducation: Icons.school_outlined,
    categoryFinance: Icons.attach_money_outlined,
    categoryOther: Icons.category_outlined,
  };

  static Map<String, Color> categoryColors = {
    categoryWork: const Color(0xFF5C6BC0),
    categoryPersonal: const Color(0xFF42A5F5),
    categoryShopping: const Color(0xFFEC407A),
    categoryHealth: const Color(0xFF66BB6A),
    categoryEducation: const Color(0xFFFFA726),
    categoryFinance: const Color(0xFF8D6E63),
    categoryOther: const Color(0xFF78909C),
  };

  // Priorities
  static const String priorityHigh = 'high';
  static const String priorityMedium = 'medium';
  static const String priorityLow = 'low';

  static const List<String> priorities = [
    priorityHigh,
    priorityMedium,
    priorityLow,
  ];

  static Map<String, Color> priorityColors = {
    priorityHigh: const Color(0xFFEF5350),
    priorityMedium: const Color(0xFFFFA726),
    priorityLow: const Color(0xFF66BB6A),
  };

  static Map<String, IconData> priorityIcons = {
    priorityHigh: Icons.local_fire_department_outlined,
    priorityMedium: Icons.star_outline,
    priorityLow: Icons.eco_outlined,
  };
}
