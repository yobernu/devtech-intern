import 'package:flutter/material.dart';
import 'package:quizapp/features/presentation/screens/leaderboard_screen.dart';
import 'package:quizapp/features/presentation/screens/quiz_app_dashboard.dart';
import 'package:quizapp/features/presentation/screens/setting_screen.dart';
import 'package:quizapp/features/presentation/screens/show_question_screen.dart';
import 'package:quizapp/features/presentation/widgets/bars/build_bottom_navbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    QuizAppDashboard(),
    LeaderBoardScreen(),
    SettingScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: _screens[_selectedIndex],
      bottomNavigationBar: buildBottomNavBar(_selectedIndex, _onItemTapped),
    );
  }
}
