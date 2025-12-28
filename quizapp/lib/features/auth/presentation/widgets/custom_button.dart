import 'package:flutter/material.dart';
import 'package:quizapp/core/constants/appcolors.dart';

class AuthButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final Color? backgroundColor;
  final Color? fgColor;
  final Color? borderColor;
  final IconData? icon;

  const AuthButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.backgroundColor = AppColors.primaryPurple,
    this.fgColor = Colors.white,
    this.borderColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: fgColor,
          side: borderColor != null ? BorderSide(color: borderColor!) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
