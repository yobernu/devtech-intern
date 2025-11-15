import 'package:flutter/material.dart';
import 'package:quizapp/core/constants/appcolors.dart';
import 'package:quizapp/features/auth/presentation/widgets/custom_button.dart';
import 'package:quizapp/features/presentation/widgets/cards/small_actions_button.dart';

class QuizResultMessage extends StatelessWidget {
  final bool isPassed;
  final String scoreLabel;
  final String categoryLabel;
  final String timeLabel;
  final String finishedTime;

  const QuizResultMessage({
    super.key,
    required this.isPassed,
    required this.scoreLabel,
    required this.categoryLabel,
    required this.timeLabel,
    required this.finishedTime,
  });

  @override
  Widget build(BuildContext context) {
    final title = isPassed
        ? "Congratulations, You Have Completed this Quiz."
        : "Oops, You Have not Passed this Quiz.";
    final icon = isPassed
        ? Icons.celebration_sharp
        : Icons.sentiment_dissatisfied;
    final iconColor = isPassed ? AppColors.accentOrange : Colors.red;

    // final percentTime = (int(finishedTime)/int(timeLabel))*100;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.darkText.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.darkText,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                "Let's keep your knowledge by playing more quizzes",
                style: TextStyle(
                  color: AppColors.darkText,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Center(child: Icon(icon, size: 48, color: iconColor)),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // ⏱ Progress / Time Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Time',
              style: TextStyle(
                color: AppColors.darkText,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: 0.1,
                  color: AppColors.accentOrange,
                  backgroundColor: AppColors.accentOrange.withOpacity(0.3),
                  minHeight: 10,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              timeLabel,
              style: const TextStyle(
                color: AppColors.darkText,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SmallActionButton(
              icon: Icons.question_answer,
              label: scoreLabel,
              color: AppColors.darkText,
            ),
            SmallActionButton(
              icon: Icons.sports_football,
              label: categoryLabel,
              color: AppColors.darkText,
            ),
            SmallActionButton(
              icon: Icons.timer,
              label: timeLabel,
              color: AppColors.darkText,
            ),
          ],
        ),

        const SizedBox(height: 140),

        // 🚀 Action Button
        AuthButton(
          onPressed: () {},
          title: "Explore More",
          bgColor: AppColors.accentOrange,
          fgColor: AppColors.surfaceWhite,
        ),
      ],
    );
  }
}

// label