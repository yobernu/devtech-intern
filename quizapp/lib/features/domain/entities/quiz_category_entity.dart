import 'package:flutter/material.dart';
import 'package:quizapp/features/domain/entities/question_entity.dart';

class QuizCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color primaryColor;
  final String description;
  final int questionCount;
  final int totalPlays;
  final List<Difficulty> availableDifficulties;
  final String imageUrl; // For category background

  QuizCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.primaryColor,
    required this.description,
    required this.questionCount,
    required this.totalPlays,
    required this.availableDifficulties,
    required this.imageUrl,
  });
}
