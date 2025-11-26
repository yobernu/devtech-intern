import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/core/constants/appcolors.dart';
// Assuming these imports are necessary for your project
import 'package:quizapp/features/domain/entities/question_entity.dart'; // Contains Difficulty enum
import 'package:quizapp/features/presentation/helpers/meshBackground.dart';
import 'package:quizapp/features/presentation/helpers/show_questions.dart'; // If ShowQuestion is a separate widget
import 'package:quizapp/features/presentation/provider/questions/questions_bloc.dart';
import 'package:quizapp/features/presentation/provider/questions/questions_events.dart';

class ShowQuestionScreen extends StatefulWidget {
  final String categoryId;
  final Difficulty difficulty;

  const ShowQuestionScreen({
    super.key,
    required this.categoryId,
    required this.difficulty,
  });

  @override
  State<ShowQuestionScreen> createState() => _ShowQuestionScreenState();
}

class _ShowQuestionScreenState extends State<ShowQuestionScreen> {
  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  void _fetchQuestions() {
    context.read<QuestionsBloc>().add(
      GetQuestionsByCategoryEvent(
        categoryId: widget.categoryId,
        difficulty: widget.difficulty,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: AppColors.darkText,
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                AppColors.surfaceWhite.withOpacity(0.8),
              ),
              shape: const WidgetStatePropertyAll(CircleBorder()),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        // title: Container(
        //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        //   child: const Text(
        //     'Question 1/10',
        //     style: TextStyle(
        //       color: AppColors.darkText,
        //       fontSize: 16,
        //       fontWeight: FontWeight.w600,
        //     ),
        //   ),
        // ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            color: AppColors.darkText,
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                AppColors.surfaceWhite.withOpacity(0.8),
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              ),
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SizedBox.expand(
        child: MeshGradientBackground(
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const ShowQuestion(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
