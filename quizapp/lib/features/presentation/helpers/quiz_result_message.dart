import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/core/constants/appcolors.dart';
import 'package:quizapp/features/auth/presentation/widgets/custom_button.dart';
import 'package:quizapp/features/domain/entities/question_entity.dart';
import 'package:quizapp/features/presentation/helpers/meshBackground.dart';
import 'package:quizapp/features/presentation/provider/categories/categories_bloc.dart';
import 'package:quizapp/features/presentation/provider/categories/categories_event.dart';
import 'package:quizapp/features/presentation/provider/categories/categories_state.dart';
import 'package:quizapp/features/presentation/widgets/cards/small_actions_button.dart';

// attemptedQuestions
class QuizResultMessage extends StatefulWidget {
  final bool isPassed;
  final String scoreLabel;
  final String categoryLabel;
  final String timeLabel;
  final String finishedTime;
  final List<Question> attemptedQuestions;

  const QuizResultMessage({
    super.key,
    required this.isPassed,
    required this.scoreLabel,
    required this.categoryLabel,
    required this.timeLabel,
    required this.finishedTime,
    required this.attemptedQuestions,
  });

  @override
  State<QuizResultMessage> createState() => _QuizResultMessageState();
}

class _QuizResultMessageState extends State<QuizResultMessage> {
  late String _displayCategoryLabel;

  @override
  void initState() {
    super.initState();
    _displayCategoryLabel = widget.categoryLabel;
    _fetchCategoryNameIfNeeded();
  }

  void _fetchCategoryNameIfNeeded() {
    if (widget.categoryLabel.isNotEmpty && widget.categoryLabel != 'General') {
      context.read<CategoriesBloc>().add(
        GetCategoryNameByIdEvent(id: widget.categoryLabel),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isPassed
        ? "Congratulations!"
        : "Better Luck Next Time!";
    final icon = widget.isPassed
        ? Icons.celebration_sharp
        : Icons.sentiment_dissatisfied;
    final iconColor = widget.isPassed ? AppColors.accentOrange : Colors.red;

    return BlocListener<CategoriesBloc, CategoriesState>(
      listener: (context, state) {
        if (state is CategoriesLoadedNameState) {
          setState(() {
            _displayCategoryLabel = state.categoryName;
          });
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: AppColors.darkText),
            onPressed: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
          ),
        ),
        body: MeshGradientBackground(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.darkText.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: AppColors.darkText,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              height: 1.3,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Let's keep your knowledge by playing more quizzes",
                            style: TextStyle(
                              color: AppColors.darkText,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceWhite.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(icon, size: 48, color: iconColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SmallActionButton(
                      icon: Icons.question_answer,
                      label: widget.scoreLabel.isEmpty
                          ? 'Score'
                          : widget.scoreLabel,
                      color: AppColors.primaryPurple,
                      onPress: () {},
                    ),
                    SmallActionButton(
                      icon: Icons.category,
                      label: _displayCategoryLabel.isEmpty
                          ? 'Category'
                          : _displayCategoryLabel,
                      color: AppColors.smallButtonTeal,
                      onPress: () {},
                    ),
                    SmallActionButton(
                      icon: Icons.timer,
                      label: widget.finishedTime.isEmpty
                          ? 'Time'
                          : widget.finishedTime,
                      color: AppColors.smallButtonYellow,
                      onPress: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 48),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'reviewAnswer');
                  },
                  child: const Text("Review questions"),
                ),
                const SizedBox(height: 48),
                AuthButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/quizDashboard',
                      (route) => false,
                    );
                  },
                  title: "Explore More",
                  bgColor: AppColors.accentOrange,
                  fgColor: AppColors.surfaceWhite,
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
