import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quizapp/core/errors/failures.dart';
import 'package:quizapp/features/domain/entities/daily_task_entity.dart';
import 'package:quizapp/features/domain/entities/question_entity.dart';
import 'package:quizapp/features/domain/entities/quiz_session_entity.dart';
import 'package:quizapp/features/domain/entities/quiz_category_entity.dart';

abstract class UserRepository {
  Future<User> getCurrentUser();
  Future<int> getUserScore();
}

abstract class QuizRepository {
  Future<Either<Failure, List<Question>>> getQuestions(
    String categoryId,
    Difficulty difficulty,
  );
  Future<Either<Failure, List<Question>>> getAllQuestions();
  Future<void> updateUserScore(int newScore);
  Future<int> getUserScore();
}

abstract class DailyTaskRepository {
  Future<DailyTask> getTodaysTask();
  Future<void> updateTaskProgress(String taskId, int completedQuestions);
}

abstract class CategoriesRepository {
  Future<Either<Failure, List<QuizCategory>>> getCategories();
  Future<Either<Failure, String>> getCategoryNameById(String id);
}
