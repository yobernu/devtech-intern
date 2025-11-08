import 'package:flutter/material.dart';
import 'package:quizapp/core/constants/appcolors.dart';
import 'package:quizapp/features/presentation/widgets/bars/build_bottom_navbar.dart';
import 'package:quizapp/features/presentation/widgets/build_more_games_section.dart';
import 'package:quizapp/features/presentation/widgets/cards/custom_pill_button.dart';
import 'package:quizapp/features/presentation/widgets/cards/daily_task_card.dart';
import 'package:quizapp/features/presentation/widgets/cards/more_game_card.dart';
import 'package:quizapp/features/presentation/widgets/quiz_categories.dart';
import 'package:quizapp/features/presentation/widgets/bars/top_bar.dart';

class QuizAppDashboard extends StatelessWidget {
  const QuizAppDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.secondaryPurple, AppColors.primaryPurple],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Top Bar
              buildTopBar(context),

              //Scrollable Content Area
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildDailyTaskCard(context),
                      buildQuizCategories(context),
                      buildMoreGamesSection(context),
                      const SizedBox(height: 50), // Extra space for bottom nav
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // --- 8. Bottom Navigation Bar ---
      bottomNavigationBar: buildBottomNavBar(),
    );
  }
}
