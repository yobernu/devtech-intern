import 'package:flutter/foundation.dart';
import 'package:quizapp/features/domain/entities/question_entity.dart';

class QuestionModel {
  final String id;
  final String categoryId;
  final String questionText;
  final QuestionType type;
  final List<AnswerOptionModel> options;
  final int correctAnswerIndex;
  final String explanation;
  final Difficulty difficulty;
  final String hint;
  final int timeLimit;
  final String? imageUrl;
  final String? audioUrl;

  const QuestionModel({
    required this.id,
    required this.categoryId,
    required this.questionText,
    required this.type,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
    required this.difficulty,
    required this.hint,
    required this.timeLimit,
    this.imageUrl,
    this.audioUrl,
  });

  /// Convert JSON → Model
  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    // Debug: Print entire JSON to see what we're working with
    debugPrint('=== QuestionModel.fromJson DEBUG ===');
    debugPrint('Full JSON: $json');
    debugPrint('Available keys: ${json.keys.toList()}');

    // Print all key-value pairs to see what's actually in the JSON
    json.forEach((key, value) {
      debugPrint('  $key: $value (type: ${value.runtimeType})');
    });

    // Try multiple possible column names for question text
    final questionTextValue =
        json['question_text'] ??
        json['questionText'] ??
        json['question'] ??
        json['text'] ??
        json['content'] ??
        json['question_content'] ??
        '';

    debugPrint('Final questionText value: "$questionTextValue"');
    debugPrint('=====================================');

    return QuestionModel(
      id: json['id'] ?? '',
      categoryId: json['category_id'] ?? json['categoryId'] ?? '',
      questionText: questionTextValue,
      type: QuestionType.values.firstWhere(
        (e) => e.toString() == 'QuestionType.${json['type']}',
        orElse: () => QuestionType.multipleChoice,
      ),
      options:
          (json['options'] as List<dynamic>?)
              ?.map((o) => AnswerOptionModel.fromJson(o))
              .toList() ??
          [],
      correctAnswerIndex:
          json['correct_answer_index'] ?? json['correctAnswerIndex'] ?? 0,
      explanation: json['explanation'] ?? '',
      difficulty: Difficulty.values.firstWhere(
        (d) => d.toString() == 'Difficulty.${json['difficulty']}',
        orElse: () => Difficulty.easy,
      ),
      timeLimit: json['time_limit'] ?? json['timeLimit'] ?? 30,
      imageUrl: json['image_url'] ?? json['imageUrl'],
      audioUrl: json['audio_url'] ?? json['audioUrl'],
      hint: json['hint'] ?? '',
    );
  }

  /// Convert Model → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'questionText': questionText,
      'type': type.toString().split('.').last,
      'options': options.map((o) => o.toJson()).toList(),
      'correctAnswerIndex': correctAnswerIndex,
      'explanation': explanation,
      'difficulty': difficulty.toString().split('.').last,
      'timeLimit': timeLimit,
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
    };
  }

  Question toEntity() {
    return Question(
      id: id,
      categoryId: categoryId,
      questionText: questionText,
      type: type,
      options: options.map((o) => o.toEntity()).toList(),
      correctAnswerIndex: correctAnswerIndex,
      explanation: explanation,
      difficulty: difficulty,
      timeLimit: timeLimit,
      imageUrl: imageUrl,
      audioUrl: audioUrl,
      hint: hint,
    );
  }

  /// Convert Entity → Model
  factory QuestionModel.fromEntity(Question entity) {
    return QuestionModel(
      id: entity.id,
      categoryId: entity.categoryId,
      questionText: entity.questionText,
      type: entity.type,
      options: entity.options
          .map((o) => AnswerOptionModel.fromEntity(o))
          .toList(),
      correctAnswerIndex: entity.correctAnswerIndex,
      explanation: entity.explanation,
      difficulty: entity.difficulty,
      timeLimit: entity.timeLimit,
      imageUrl: entity.imageUrl,
      audioUrl: entity.audioUrl,
      hint: entity.hint,
    );
  }
}

class AnswerOptionModel {
  final String text;
  final String? imageUrl;

  const AnswerOptionModel({required this.text, this.imageUrl});

  factory AnswerOptionModel.fromJson(Map<String, dynamic> json) {
    return AnswerOptionModel(
      text: json['text'] ?? '',
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'text': text, 'imageUrl': imageUrl};
  }

  AnswerOption toEntity() {
    return AnswerOption(text: text, imageUrl: imageUrl);
  }

  factory AnswerOptionModel.fromEntity(AnswerOption entity) {
    return AnswerOptionModel(text: entity.text, imageUrl: entity.imageUrl);
  }
}
