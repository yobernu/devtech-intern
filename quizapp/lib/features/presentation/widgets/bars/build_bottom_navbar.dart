import 'package:flutter/material.dart';
import 'package:quizapp/core/constants/appcolors.dart';
import 'package:quizapp/features/presentation/widgets/bars/build_nav_item.dart';
Widget buildBottomNavBar() {
  return Container(
    margin: EdgeInsets.only(bottom: 20, right: 40, left: 40, top: 20),
    height: 71,
    decoration: BoxDecoration(
      color: AppColors.accentPink,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
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
      children: const [
        AnimatedNavItem(icon: Icons.explore, label: 'Explore'),
        AnimatedNavItem(icon: Icons.leaderboard_outlined, label: 'Leaderboard', isActive: true,),
        AnimatedNavItem(icon: Icons.bookmark_outline, label: 'Bookmarks'),
        AnimatedNavItem(icon: Icons.settings_outlined, label: 'Settings'),
      ],
    ),
  );
}