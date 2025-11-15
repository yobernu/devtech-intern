import 'package:flutter/material.dart';
import 'package:quizapp/core/constants/appcolors.dart';
import 'package:quizapp/features/presentation/widgets/cards/small_actions_button.dart';
import 'package:quizapp/features/presentation/widgets/quiz_option_tiles.dart';

class ShowQuestion extends StatelessWidget {
  const ShowQuestion({super.key});

  // Mock data to represent the state shown in the image
  final String _questionText =
      'Which soccer team won the FIFA World Cup for the first time Which soccer team won the FIFA World Cup for the first time?';
  final List<Map<String, dynamic>> _options = const [
    {'prefix': 'A', 'text': 'Uruguay', 'isCorrect': true, 'isSelected': false},
    {'prefix': 'B', 'text': 'Brazil', 'isCorrect': false, 'isSelected': false},
    {'prefix': 'C', 'text': 'Italy', 'isCorrect': false, 'isSelected': false},
    {'prefix': 'D', 'text': 'Germany', 'isCorrect': false, 'isSelected': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // question show space
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                const Color.fromARGB(255, 102, 84, 193).withOpacity(0.25),
                const Color.fromARGB(255, 255, 255, 255),
              ],
              center: Alignment.center,
              radius: 0.95,
              focal: Alignment.topCenter,
              focalRadius: 0.3,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.darkText.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Text(
            _questionText,
            style: const TextStyle(
              color: AppColors.darkText,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        // --- Time and Progress Bar ---
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
                  value: 0.3,
                  color: AppColors.accentOrange,
                  backgroundColor: AppColors.accentOrange.withOpacity(0.3),
                  minHeight: 10,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              '00:12',
              style: TextStyle(
                color: AppColors.darkText,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // --- Answer Options List ---
        ..._options.map((option) {
          return QuizOptionTile(
            optionText: option['text'],
            prefix: option['prefix'],
            isCorrectAnswer: option['isCorrect'],
            isSelected: option['isSelected'],
          );
        }).toList(),

        // Using Spacer() with a surrounding Flexible in a Column can be tricky,
        // so I'm replacing it with Sized Box and wrapping the Row in Flexible.

        const Spacer(),
        SizedBox(height: 40,),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              SmallActionButton(
                icon: Icons.person_add_alt_1,
                label: '50/50',
                color: AppColors.accentOrange,
              ),
              const SizedBox(width: 12),
              SmallActionButton(
                icon: Icons.people_alt,
                label: 'Audience',
                color: AppColors.accentOrange,
              ),
              // const SizedBox(width: 12),
              // SmallActionButton(
              //   icon: Icons.timer,
              //   label: 'Add Time',
              //   color: AppColors.accentOrange,
              // ),
              const SizedBox(width: 12),
              SmallActionButton(
                icon: Icons.skip_next,
                label: 'Skip',
                color: AppColors.accentOrange,
              ),
              const SizedBox(width: 12),
              // You can add more easily now
              SmallActionButton(
                icon: Icons.lightbulb,
                label: 'Hint',
                color: AppColors.accentOrange,
              ),
            ],
          ),
        ),

        const SizedBox(height: 40),
      ],
    );
  }
}











// ✅ Unified Pass/Fail Message Widget
