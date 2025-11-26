import 'package:flutter/material.dart';
import 'package:quizapp/core/constants/appcolors.dart';
import 'package:quizapp/features/auth/presentation/widgets/custom_button.dart';
import 'package:quizapp/features/domain/entities/question_entity.dart';

class CheckAnswers extends StatelessWidget {
  final List<Question> questions;
  const CheckAnswers({super.key, required this.questions});

  @override
  Widget build(BuildContext context) {
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
              const Text(
                "Check Your results below",
                style: TextStyle(
                  color: AppColors.darkText,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        ListView.builder(
          itemCount: 15,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return const ListTile(
              title: Text("A"),
              hoverColor: AppColors.accentOrange,
              subtitle: Text(
                "Which soccer team won the FIFA World Cup for the first time Which soccer team won the FIFA World Cup for the first time?",
              ),
            );
          },
        ),

        const SizedBox(height: 40),
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
