import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/core/constants/appcolors.dart';
import 'package:quizapp/features/auth/presentation/widgets/custom_button.dart';
import 'package:quizapp/features/domain/entities/question_entity.dart';
import 'package:quizapp/features/presentation/helpers/meshBackground.dart';
import 'package:quizapp/features/presentation/provider/categories/categories_bloc.dart';
import 'package:quizapp/features/presentation/provider/categories/categories_event.dart';
import 'package:quizapp/features/presentation/provider/categories/categories_state.dart';

class CheckAnswers extends StatefulWidget {
  final List<Question> questions;
  final String categoryName;
  final Difficulty difficulty;

  const CheckAnswers({
    super.key,
    required this.questions,
    required this.categoryName,
    required this.difficulty,
  });

  @override
  State<CheckAnswers> createState() => _CheckAnswersState();
}

class _CheckAnswersState extends State<CheckAnswers> {
  late String _displayCategoryName;
  final Map<String, bool> _expandedExplanations = {};

  @override
  void initState() {
    super.initState();
    _displayCategoryName = widget.categoryName;

    // If category name looks like a UUID, try to fetch the real name
    if (_isUUID(widget.categoryName)) {
      context.read<CategoriesBloc>().add(
        GetCategoryNameByIdEvent(id: widget.categoryName),
      );
    }
  }

  bool _isUUID(String value) {
    final uuidPattern = RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
      caseSensitive: false,
    );
    return uuidPattern.hasMatch(value);
  }

  String _getDifficultyLabel(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return 'Easy';
      case Difficulty.medium:
        return 'Medium';
      case Difficulty.hard:
        return 'Hard';
      case Difficulty.expert:
        return 'Expert';
    }
  }

  Color _getDifficultyColor(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return AppColors.correctGreen;
      case Difficulty.medium:
        return AppColors.smallButtonYellow;
      case Difficulty.hard:
        return AppColors.accentOrange;
      case Difficulty.expert:
        return AppColors.incorrectRed;
    }
  }

  IconData _getDifficultyIcon(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return Icons.sentiment_satisfied;
      case Difficulty.medium:
        return Icons.sentiment_neutral;
      case Difficulty.hard:
        return Icons.sentiment_dissatisfied;
      case Difficulty.expert:
        return Icons.warning;
    }
  }

  int _getCorrectAnswersCount() {
    // Note: This assumes questions have a userAnswerIndex property
    // If not available, we'll need to track it differently
    return widget.questions.where((q) {
      // For now, we can't determine user's answer without additional data
      // This would need to be passed from the quiz screen
      return false;
    }).length;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CategoriesBloc, CategoriesState>(
      listener: (context, state) {
        if (state is CategoriesLoadedNameState) {
          setState(() {
            _displayCategoryName = state.categoryName;
          });
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.darkText),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'Quiz Review',
            style: TextStyle(
              color: AppColors.darkText,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
        ),
        body: MeshGradientBackground(
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Card with Category and Difficulty
                  _buildHeaderCard(),

                  const SizedBox(height: 24),

                  // Statistics Summary
                  _buildStatisticsCard(),

                  const SizedBox(height: 32),

                  // Questions List
                  const Text(
                    'Questions Review',
                    style: TextStyle(
                      color: AppColors.darkText,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 16),

                  ...List.generate(
                    widget.questions.length,
                    (index) => _buildQuestionCard(index),
                  ),

                  const SizedBox(height: 32),

                  // Back to Dashboard Button
                  AuthButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/quizDashboard',
                        (route) => false,
                      );
                    },
                    title: "Back to Dashboard",
                    backgroundColor: AppColors.primaryPurple,
                    fgColor: AppColors.surfaceWhite,
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkText.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.category,
                  color: AppColors.primaryPurple,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Category',
                      style: TextStyle(
                        color: AppColors.darkText,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _displayCategoryName,
                      style: const TextStyle(
                        color: AppColors.darkText,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: _getDifficultyColor(widget.difficulty).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getDifficultyIcon(widget.difficulty),
                  color: _getDifficultyColor(widget.difficulty),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  _getDifficultyLabel(widget.difficulty),
                  style: TextStyle(
                    color: _getDifficultyColor(widget.difficulty),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCard() {
    final totalQuestions = widget.questions.length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkText.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quiz Statistics',
            style: TextStyle(
              color: AppColors.darkText,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                Icons.quiz,
                'Total',
                totalQuestions.toString(),
                AppColors.primaryPurple,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: AppColors.darkText.withOpacity(0.6),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionCard(int index) {
    final question = widget.questions[index];
    final questionKey = 'question_$index';
    final isExpanded = _expandedExplanations[questionKey] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkText.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryPurple.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPurple,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Q${index + 1}',
                    style: const TextStyle(
                      color: AppColors.surfaceWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    question.questionText,
                    style: const TextStyle(
                      color: AppColors.darkText,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Question Image (if available)
          if (question.imageUrl != null && question.imageUrl!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  question.imageUrl!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: AppColors.darkText.withOpacity(0.1),
                      child: const Center(
                        child: Icon(Icons.broken_image, size: 48),
                      ),
                    );
                  },
                ),
              ),
            ),

          // Answer Options
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...List.generate(
                  question.options.length,
                  (optionIndex) => _buildAnswerOption(question, optionIndex),
                ),
              ],
            ),
          ),

          // Explanation Section
          if (question.explanation.isNotEmpty)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              decoration: BoxDecoration(
                color: AppColors.primaryPurple.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        _expandedExplanations[questionKey] = !isExpanded;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.lightbulb_outline,
                            color: AppColors.primaryPurple,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Explanation',
                            style: TextStyle(
                              color: AppColors.primaryPurple,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: AppColors.primaryPurple,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isExpanded)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      child: Text(
                        question.explanation,
                        style: TextStyle(
                          color: AppColors.darkText.withOpacity(0.8),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAnswerOption(Question question, int optionIndex) {
    final option = question.options[optionIndex];
    final isCorrect = optionIndex == question.correctAnswerIndex;
    final optionLetter = String.fromCharCode('A'.codeUnitAt(0) + optionIndex);

    Color backgroundColor;
    Color borderColor;
    Color textColor;
    IconData? icon;

    if (isCorrect) {
      backgroundColor = AppColors.correctGreen.withOpacity(0.1);
      borderColor = AppColors.correctGreen;
      textColor = AppColors.correctGreen;
      icon = Icons.check_circle;
    } else {
      backgroundColor = Colors.transparent;
      borderColor = AppColors.darkText.withOpacity(0.2);
      textColor = AppColors.darkText;
      icon = null;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isCorrect
                  ? AppColors.correctGreen
                  : AppColors.darkText.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                optionLetter,
                style: TextStyle(
                  color: isCorrect
                      ? AppColors.surfaceWhite
                      : AppColors.darkText,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              option.text,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: isCorrect ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
          if (icon != null) Icon(icon, color: textColor, size: 24),
        ],
      ),
    );
  }
}
