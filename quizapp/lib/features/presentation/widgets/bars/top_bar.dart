import "package:flutter/material.dart";
import "package:quizapp/core/constants/appcolors.dart";

Widget buildTopBar(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
    child: Row(
      children: [
        // Profile Info
        const CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(
            'https://placehold.co/100x100/A066FF/FFFFFF?text=R',
          ),
          backgroundColor: AppColors.surfaceWhite,
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              // user name
              'Roxane Harley',
              style: TextStyle(
                color: AppColors.surfaceWhite,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              'Expert',
              style: TextStyle(color: AppColors.surfaceWhite, fontSize: 12),
            ),
          ],
        ),
        const Spacer(),
        // Score Card
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surfaceWhite.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            children: [
              Icon(Icons.flash_on, color: AppColors.accentPink, size: 20),
              SizedBox(width: 4),
              Text(
                '1200',
                style: TextStyle(
                  color: AppColors.surfaceWhite,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
