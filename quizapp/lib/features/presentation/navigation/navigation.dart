import 'package:flutter/material.dart';
import 'package:quizapp/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:quizapp/features/auth/presentation/screens/login_screen.dart';
import 'package:quizapp/features/auth/presentation/screens/signup_screen.dart';
import 'package:quizapp/features/presentation/screens/quiz_app_dashboard.dart';
import 'package:quizapp/features/presentation/screens/show_question_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String forgotPassword = '/forgotPassword';
  static const String showQuestion = '/showQuestion';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    signup: (context) => const SignupScreen(),
    home: (context) => const QuizAppDashboard(),
    forgotPassword: (context) => const ForgotPasswordScreen(),
    showQuestion: (context) => const ShowQuestionScreen(),
  };
}
