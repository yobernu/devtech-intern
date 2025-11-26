import 'package:flutter/material.dart';
import 'package:quizapp/core/constants/appcolors.dart';

class QuizOptionTile extends StatelessWidget {
  final String optionText;
  final String prefix;
  final bool isCorrectAnswer;
  final bool isSelected;
  final bool isHidden; // New parameter for 50/50
  final VoidCallback? onTap;

  const QuizOptionTile({
    super.key,
    required this.optionText,
    required this.prefix,
    this.isCorrectAnswer = false,
    this.isSelected = false,
    this.isHidden = false,
    this.onTap,
  });

  Color _getTileColor() {
    if (isSelected) {
      return isCorrectAnswer
          ? AppColors.correctGreen.withOpacity(0.95)
          : Colors.red.withOpacity(0.1); // Red background for incorrect
    }
    return AppColors.surfaceWhite.withOpacity(0.95);
  }

  Color _getTextColor() {
    if (isSelected) {
      return isCorrectAnswer
          ? AppColors.surfaceWhite
          : Colors.red; // Red text for incorrect
    }
    return AppColors.darkText;
  }

  IconData? _getTrailingIcon() {
    if (isSelected) {
      return isCorrectAnswer
          ? Icons.check_circle
          : Icons.cancel; // X icon for incorrect
    }
    return Icons.circle_outlined;
  }

  @override
  Widget build(BuildContext context) {
    if (isHidden) {
      return const SizedBox.shrink(); // Hide if 50/50 active
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _getTileColor(),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? (isCorrectAnswer
                        ? AppColors.correctGreen
                        : Colors.red) // Red border for incorrect
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
                color: isSelected
                    ? (isCorrectAnswer
                          ? AppColors.primaryPurple
                          : Colors.red) // Red icon for incorrect
                    : AppColors.darkText.withOpacity(0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
