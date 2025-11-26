import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quizapp/features/domain/entities/question_entity.dart';
import 'package:quizapp/features/domain/entities/quiz_category_entity.dart';

class QuizCategoryModel implements QuizCategory {
  @override
  final String id;
  @override
  final String name;
  @override
  final IconData icon;
  @override
  final Color primaryColor;
  @override
  final String description;
  @override
  final int questionCount;
  @override
  final int totalPlays;
  @override
  final List<Difficulty> availableDifficulties;
  @override
  final String imageUrl;

  const QuizCategoryModel({
    this.id = '0',
    this.name = '',
    this.icon = Icons.help_outline,
    this.primaryColor = const Color(0xFF000000),
    this.description = '',
    this.questionCount = 0,
    this.totalPlays = 0,
    this.availableDifficulties = const [],
    this.imageUrl = '',
  });

  factory QuizCategoryModel.fromJson(Map<String, dynamic> json) {
    return QuizCategoryModel(
      id: json['id'] ?? '0',
      name: json['name'] ?? '',
      icon: Icons
          .help_outline, // ⚠️ You’ll need a mapping if API sends icon names
      primaryColor: const Color(0xFF000000), // ⚠️ Same for colors
      description: json['description'] ?? '',
      questionCount: json['questionCount'] ?? 0,
      totalPlays: json['totalPlays'] ?? 0,
      availableDifficulties:
          (json['availableDifficulties'] as List<dynamic>?)
              ?.map(
                (e) => Difficulty.values.firstWhere(
                  (d) => d.toString() == e,
                  orElse: () => Difficulty.easy,
                ),
              )
              .toList() ??
          const [],
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon.codePoint, // ⚠️ IconData serialization
      'primaryColor': primaryColor.value, // ⚠️ Color serialization
      'description': description,
      'questionCount': questionCount,
      'totalPlays': totalPlays,
      'availableDifficulties': availableDifficulties
          .map((d) => d.toString())
          .toList(),
      'imageUrl': imageUrl,
    };
  }

  QuizCategory toEntity() {
    return QuizCategory(
      id: id,
      name: name,
      icon: icon,
      primaryColor: primaryColor,
      description: description,
      questionCount: questionCount,
      totalPlays: totalPlays,
      availableDifficulties: availableDifficulties,
      imageUrl: imageUrl,
    );
  }

  factory QuizCategoryModel.fromEntity(QuizCategory entity) {
    return QuizCategoryModel(
      id: entity.id,
      name: entity.name,
      icon: entity.icon,
      primaryColor: entity.primaryColor,
      description: entity.description,
      questionCount: entity.questionCount,
      totalPlays: entity.totalPlays,
      availableDifficulties: entity.availableDifficulties,
      imageUrl: entity.imageUrl,
    );
  }
}
