import 'package:flutter/material.dart';
import 'package:quizapp/core/constants/appcolors.dart';

class QuizOptionTile extends StatelessWidget {
  final String optionText;
  final String prefix;
  final bool isCorrectAnswer;
  final bool isSelected;
  final String hint;

  const QuizOptionTile({
    super.key,
    required this.optionText,
    required this.prefix,
    this.isCorrectAnswer = false,
    this.isSelected = false,
    this.hint = "No hints"
  });

  Color _getTileColor() {
    if (isCorrectAnswer && isSelected) {
      return AppColors.correctGreen.withOpacity(0.95);
    }
    return AppColors.surfaceWhite.withOpacity(0.95);
  }

  Color _getTextColor() {
    if (isCorrectAnswer && isSelected) {
      return AppColors.surfaceWhite;
    }
    return AppColors.darkText;
  }

  IconData? _getTrailingIcon() {
    if (isCorrectAnswer && isSelected) {
      return Icons.check_circle;
    }
    return Icons.circle_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _getTileColor(),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected && isCorrectAnswer
                ? AppColors.correctGreen
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkText.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Prefix (A, B, C, D)
            Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              child: Text(
                prefix,
                style: TextStyle(
                  color: _getTextColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Option Text
            Expanded(
              child: Text(
                optionText,
                style: TextStyle(
                  fontSize: 18,
                  color: _getTextColor(),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // Trailing Icon
            Icon(
              _getTrailingIcon(),
              color: isCorrectAnswer
                  ? AppColors.correctGreen
                  : AppColors.darkText.withOpacity(0.4),
            ),
          ],
        ),
      ),
    );
  }
}
