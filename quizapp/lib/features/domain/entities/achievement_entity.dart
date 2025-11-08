import 'package:flutter/material.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final int targetValue;
  final int currentValue;
  final AchievementType type;
  final bool isUnlocked;
  final int rewardPoints;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.targetValue,
    required this.currentValue,
    required this.type,
    required this.isUnlocked,
    required this.rewardPoints,
  });
}

enum AchievementType {
  totalQuizzes,
  perfectScores,
  streakDays,
  categoryMaster,
  friendInvites,
}
