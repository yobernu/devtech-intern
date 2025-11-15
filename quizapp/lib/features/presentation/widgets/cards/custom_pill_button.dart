// Custom widget for a modern rounded button with shadow
import 'package:flutter/material.dart';
import 'package:quizapp/core/constants/appcolors.dart';

class CustomPillButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPress; 

  const CustomPillButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onPress,
  });

  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPress,
          child: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Icon(icon, color: AppColors.surfaceWhite, size: 28),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.darkText,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
