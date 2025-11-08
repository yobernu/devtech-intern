import 'package:flutter/material.dart';
import 'package:quizapp/core/constants/appcolors.dart';
import 'package:quizapp/core/constants/auth_services.dart';
import 'package:quizapp/features/auth/presentation/screens/login_screen.dart';
import 'package:quizapp/features/auth/presentation/screens/signup_screen.dart';
import 'package:quizapp/features/presentation/navigation/navigation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  runApp(const MyApp());
  Supabase.initialize(
    url: AuthService.supabaseUrl,
    anonKey: AuthService.supabaseAnonKey,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App UI',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: AppColors.surfaceWhite,
      ),
      routes: AppRoutes.routes,
      initialRoute: AppRoutes.showQuestion,
      debugShowCheckedModeBanner: false,
    );
  }
}
