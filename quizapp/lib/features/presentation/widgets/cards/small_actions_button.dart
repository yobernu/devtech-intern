import 'package:flutter/material.dart';
import 'package:quizapp/core/constants/appcolors.dart';

class SmallActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPress;

  const SmallActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onPress
  });

  @override
  Widget build(BuildContext context) { 
    return Column(
      children: [
        GestureDetector(
          onTap: onPress,
          child: Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: AppColors.smallButtonBlue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(icon, color: AppColors.surfaceWhite, size: 24),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.lightSurface,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
