import 'package:flutter/material.dart';
import 'package:quizapp/core/constants/appcolors.dart';
import 'package:quizapp/features/presentation/widgets/bars/build_nav_item.dart';

Widget buildBottomNavBar() {
  return Container(
    height: 70, // Height for the bottom nav bar
    decoration: BoxDecoration(
      color: AppColors.surfaceWhite,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 20,
          offset: const Offset(0, -5),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        buildNavItem(Icons.explore, 'Explore', isActive: true),
        buildNavItem(Icons.leaderboard_outlined, 'Leaderboard'),
        buildNavItem(Icons.bookmark_outline, 'Bookmarks'),
        buildNavItem(Icons.settings_outlined, 'Settings'),
      ],
    ),
  );
}
