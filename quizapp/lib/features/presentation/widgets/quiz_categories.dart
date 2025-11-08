import 'package:flutter/material.dart';
import 'package:quizapp/core/constants/appcolors.dart';
import 'package:quizapp/features/presentation/widgets/cards/custom_pill_button.dart';

Widget buildQuizCategories(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(top: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quiz',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.surfaceWhite,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'View All',
                  style: TextStyle(color: AppColors.surfaceWhite),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Horizontal list of categories (Pill Buttons)
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            children: [
              CustomPillButton(
                icon: Icons.sports_soccer,
                label: 'Football',
                color: Color(0xFFE45B41), // Custom accent color
                onPress: () {
                  Navigator.pushNamed(context, '/showQuestion');
                },
              ),
              SizedBox(width: 16),
              CustomPillButton(
                icon: Icons.lightbulb_outline,
                label: 'Science',
                color: Color(0xFF41A8E4),
                onPress: () {
                  Navigator.pushNamed(context, '/showQuestion');
                },
              ),
              SizedBox(width: 16),
              CustomPillButton(
                icon: Icons.shopping_bag_outlined,
                label: 'Fashion',
                color: Color(0xFFE441A8),
                onPress: () {
                  Navigator.pushNamed(context, '/showQuestion');
                },
              ),
              SizedBox(width: 16),
              CustomPillButton(
                icon: Icons.movie_outlined,
                label: 'Movie',
                color: Color(0xFF41E45B),
                onPress: () {
                  Navigator.pushNamed(context, '/showQuestion');
                },
              ),
              SizedBox(width: 16),
              CustomPillButton(
                icon: Icons.music_note_outlined,
                label: 'Music',
                color: Color(0xFFE4B641),
                onPress: () {
                  Navigator.pushNamed(context, '/showQuestion');
                },
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
