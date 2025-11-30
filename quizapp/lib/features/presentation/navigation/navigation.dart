import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:quizapp/features/auth/presentation/screens/login_screen.dart';
import 'package:quizapp/features/auth/presentation/screens/signup_screen.dart';
import 'package:quizapp/features/domain/entities/question_entity.dart';
import 'package:quizapp/features/presentation/di_container.dart' as di;
import 'package:quizapp/features/presentation/helpers/check_answers.dart';
import 'package:quizapp/features/presentation/helpers/quiz_result_message.dart';
import 'package:quizapp/features/presentation/provider/categories/categories_bloc.dart';
import 'package:quizapp/features/presentation/screens/difficulty_selection_screen.dart';
import 'package:quizapp/features/presentation/screens/homescreen.dart';
import 'package:quizapp/features/presentation/screens/quiz_app_dashboard.dart';
import 'package:quizapp/features/presentation/screens/show_question_screen.dart';

// Helper function to convert a string to a Difficulty enum instance
Difficulty _parseDifficulty(String? difficultyString) {
  if (difficultyString == null) {
    return Difficulty.easy;
  }
  switch (difficultyString.toLowerCase()) {
    case 'medium':
      return Difficulty.medium;
    case 'hard':
      return Difficulty.hard;
    case 'easy':
    default:
      return Difficulty.easy;
  }
}

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String quizDashboard = '/quizDashboard';
  static const String forgotPassword = '/forgotPassword';
  static const String difficultySelection = '/difficultySelection';
  static const String showQuestion = '/showQuestion';
  static const String resultScreen = '/resultScreen';
  static const String reviewAnswer = '/reviewAnswer';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    quizDashboard: (context) => const QuizAppDashboard(),
    signup: (context) => const SignupScreen(),
    home: (context) => const HomeScreen(),
    forgotPassword: (context) => const ForgotPasswordScreen(),
    difficultySelection: (context) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final categoryId = args?['categoryId'] as String? ?? '';
      final categoryName = args?['categoryName'] as String? ?? 'Quiz';

      if (categoryId.isEmpty) {
        return const Scaffold(
          body: Center(child: Text('Error: Category not found.')),
        );
      }

      return DifficultySelectionScreen(
        categoryId: categoryId,
        categoryName: categoryName,
      );
    },
    resultScreen: (context) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      final isPassed = args?['isPassed'] as bool? ?? false;
      final scoreLabel = args?['scoreLabel'] as String? ?? '';

      final categoryLabelRaw = args?['categoryLabel'];
      final categoryLabel = categoryLabelRaw?.toString() ?? '';

      final timeLabel = args?['timeLabel'] as String? ?? '';
      final finishedTime = args?['finishedTime'] as String? ?? '';
      final attemptedQuestions =
          args?['attemptedQuestions'] as List<Question>? ?? [];

      return BlocProvider(
        create: (context) => di.sl<CategoriesBloc>(),
        child: QuizResultMessage(
          isPassed: isPassed,
          scoreLabel: scoreLabel,
          categoryLabel: categoryLabel,
          timeLabel: timeLabel,
          finishedTime: finishedTime,
          attemptedQuestions: attemptedQuestions,
        ),
      );
    },

    showQuestion: (context) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final categoryId = args?['categoryId'] as String? ?? '';
      final difficultyString = args?['difficulty'] as String?;
      final difficulty = _parseDifficulty(difficultyString);
      if (categoryId.isEmpty) {
        return const Scaffold(
          body: Center(child: Text('Error: Quiz parameters missing.')),
        );
      }

      return ShowQuestionScreen(categoryId: categoryId, difficulty: difficulty);
    },

    reviewAnswer: (context) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final questions = args?['questions'] as List<Question>? ?? [];
      final categoryName = args?['categoryName'] as String? ?? 'Quiz';
      final difficultyString = args?['difficulty'] as String?;
      final difficulty = _parseDifficulty(difficultyString);

      if (questions.isEmpty) {
        return const Scaffold(
          body: Center(child: Text('Error: No questions to review.')),
        );
      }

      return BlocProvider(
        create: (context) => di.sl<CategoriesBloc>(),
        child: CheckAnswers(
          questions: questions,
          categoryName: categoryName,
          difficulty: difficulty,
        ),
      );
    },
  };
}
