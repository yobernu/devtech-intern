import 'package:flutter/material.dart';
import 'package:quizapp/core/constants/appcolors.dart';

Widget buildNavItem(IconData icon, String label, {bool isActive = false}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        icon,
        color: isActive ? AppColors.primaryPurple : Colors.grey.shade400,
        size: 28,
      ),
      Text(
        label,
        style: TextStyle(
          color: isActive ? AppColors.primaryPurple : Colors.grey.shade400,
          fontSize: 10,
          fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    ],
  );
}
