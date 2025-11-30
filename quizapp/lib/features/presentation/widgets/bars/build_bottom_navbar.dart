import 'package:flutter/material.dart';
import 'package:quizapp/core/constants/appcolors.dart';
import 'package:quizapp/features/presentation/widgets/bars/build_nav_item.dart';

Widget buildBottomNavBar(int selectedIndex, Function(int) onItemTapped) {
  return Container(
    margin: const EdgeInsets.only(bottom: 20, right: 40, left: 40, top: 20),
    height: 71,
    decoration: BoxDecoration(
      color: AppColors.primaryPurple.withOpacity(0.5),
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
      children: [
        AnimatedNavItem(
          icon: Icons.explore,
          label: 'Explore',
          isActive: selectedIndex == 0,
          onTap: () => onItemTapped(0),
        ),

        AnimatedNavItem(
          icon: Icons.leaderboard_outlined,
          label: 'Leaderboard',
          isActive: selectedIndex == 1,
          onTap: () => onItemTapped(1),
        ),
        AnimatedNavItem(
          icon: Icons.settings_outlined,
          label: 'Settings',
          isActive: selectedIndex == 2,
          onTap: () => onItemTapped(2),
        ),
      ],
    ),
  );
}
