import 'package:flutter/material.dart';
import 'package:quizapp/core/constants/appcolors.dart';
import 'package:quizapp/features/presentation/widgets/cards/more_game_card.dart';

Widget buildMoreGamesSection(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(top: 24.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'More Games',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.surfaceWhite,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'View Alls',
                  style: TextStyle(color: AppColors.surfaceWhite),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            children: [
              MoreGameCard(
                title: 'Language Quiz',
                questions: '15 Questions',
                score: '24.7K',
                icon: Icons.menu_book,
                gradientStart: const Color(0xFFF962FF),
                gradientEnd: const Color(0xFF904EFE),
                subtitle: '',
              ),
              MoreGameCard(
                title: 'Exam Quiz',
                questions: '12 Questions',
                score: '12.5K',
                icon: Icons.military_tech_outlined,
                gradientStart: const Color(0xFFFFCC33),
                gradientEnd: const Color(0xFFFF9900),
                subtitle: '',
              ),
              MoreGameCard(
                title: 'Language Quiz',
                questions: '15 Questions',
                score: '24.7K',
                icon: Icons.menu_book,
                gradientStart: const Color(0xFFF962FF),
                gradientEnd: const Color(0xFF904EFE),
                subtitle: '',
              ),
              MoreGameCard(
                title: 'Exam Quiz',
                questions: '12 Questions',
                score: '12.5K',
                icon: Icons.military_tech_outlined,
                gradientStart: const Color(0xFFFFCC33),
                gradientEnd: const Color(0xFFFF9900),
                subtitle: '',
              ),
              MoreGameCard(
                title: 'Language Quiz',
                questions: '15 Questions',
                score: '24.7K',
                icon: Icons.menu_book,
                gradientStart: const Color(0xFFF962FF),
                gradientEnd: const Color(0xFF904EFE),
                subtitle: '',
              ),
              MoreGameCard(
                title: 'Exam Quiz',
                questions: '12 Questions',
                score: '12.5K',
                icon: Icons.military_tech_outlined,
                gradientStart: const Color(0xFFFFCC33),
                gradientEnd: const Color(0xFFFF9900),
                subtitle: '',
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
