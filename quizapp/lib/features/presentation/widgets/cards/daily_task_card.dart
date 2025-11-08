import "package:flutter/material.dart";
import "package:quizapp/core/constants/appcolors.dart";

Widget buildDailyTaskCard(BuildContext context) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.surfaceWhite.withOpacity(0.2),
      borderRadius: BorderRadius.circular(25),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 15,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceWhite.withOpacity(0.2),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.anchor,
                color: AppColors.surfaceWhite,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            // Text Content
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Task',
                    style: TextStyle(
                      color: AppColors.surfaceWhite,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    '14 Questions',
                    style: TextStyle(
                      color: AppColors.surfaceWhite,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            // Add Button
            Container(
              decoration: BoxDecoration(
                color: AppColors.accentPink,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.add,
                color: AppColors.surfaceWhite,
                size: 24,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Progress Bar
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: 8 / 14, // Example progress
                backgroundColor: AppColors.surfaceWhite.withOpacity(0.4),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.accentPink,
                ),
                borderRadius: BorderRadius.circular(10),
                minHeight: 10,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              '8/14',
              style: TextStyle(
                color: AppColors.surfaceWhite,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
