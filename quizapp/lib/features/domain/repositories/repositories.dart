import 'package:firebase_auth/firebase_auth.dart';
import 'package:quizapp/features/domain/entities/daily_task_entity.dart';
import 'package:quizapp/features/domain/entities/question_entity.dart';
import 'package:quizapp/features/domain/entities/quiz_session_entity.dart';
import 'package:quizapp/features/domain/entities/quiz_category_entity.dart';

abstract class UserRepository {
  Future<User> getCurrentUser();
  Future<void> updateUserScore(int newScore);
  Future<void> updateUserStats(Map<String, int> categoryStats);
}

abstract class QuizRepository {
  Future<List<QuizCategory>> getCategories();
  Future<List<Question>> getQuestions(String categoryId, Difficulty difficulty);
  Future<QuizSession> startQuizSession(QuizSession session);
  Future<void> submitAnswer(UserAnswer answer);
  Future<QuizSession> completeQuizSession(String sessionId);
}

abstract class DailyTaskRepository {
  Future<DailyTask> getTodaysTask();
  Future<void> updateTaskProgress(String taskId, int completedQuestions);
}
