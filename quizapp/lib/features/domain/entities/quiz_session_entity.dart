import 'package:quizapp/features/domain/entities/question_entity.dart';

class QuizSession {
  final String id;
  final String userId;
  final String categoryId;
  final List<Question> questions;
  final List<UserAnswer> userAnswers;
  final DateTime startTime;
  final DateTime? endTime;
  final int score;
  final int correctAnswers;
  final QuizType type;
  final SessionStatus status;

  QuizSession({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.questions,
    required this.userAnswers,
    required this.startTime,
    this.endTime,
    required this.score,
    required this.correctAnswers,
    required this.type,
    required this.status,
  });
}

class UserAnswer {
  final String questionId;
  final int selectedAnswerIndex;
  final bool isCorrect;
  final int timeTaken; // in seconds

  UserAnswer({
    required this.questionId,
    required this.selectedAnswerIndex,
    required this.isCorrect,
    required this.timeTaken,
  });
}

enum QuizType { dailyChallenge, categoryQuiz, multiplayer, timedChallenge }

enum SessionStatus { inProgress, completed, abandoned }
