import 'package:flutter/material.dart';

class GamePackage {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color gradientStart;
  final Color gradientEnd;
  final int questionCount;
  final int downloadCount;
  final List<String> categoryIds;
  final bool isPremium;
  final double rating;

  GamePackage({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradientStart,
    required this.gradientEnd,
    required this.questionCount,
    required this.downloadCount,
    required this.categoryIds,
    required this.isPremium,
    required this.rating,
  });
}
