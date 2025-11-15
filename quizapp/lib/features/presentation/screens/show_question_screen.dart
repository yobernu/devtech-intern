import 'package:flutter/material.dart';
import 'package:quizapp/core/constants/appcolors.dart';
import 'package:quizapp/features/presentation/helpers/quiz_result_message.dart';
import 'package:quizapp/features/presentation/helpers/show_questions.dart';

class ShowQuestionScreen extends StatelessWidget {
  const ShowQuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
              shape: WidgetStatePropertyAll(
                CircleBorder(),
              ),
            ),
            onPressed: () {},
          ),
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          // decoration: BoxDecoration(
          //   color: AppColors.surfaceWhite.withOpacity(0.3),
          //   borderRadius: BorderRadius.circular(20),
          // ),
          child: const Text(
            'Question 3/10',
            style: TextStyle(
              color: AppColors.surfaceWhite,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
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
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryPurple, AppColors.lightSurface],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Container(
                // height: size.height * 0.9,
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

                // 🔹 Change between pass/fail easily
                // child: QuizResultMessage(
                //   isPassed: false, // change this to false for failure message
                //   scoreLabel: "4/10",
                //   categoryLabel: "Football",
                //   timeLabel: "00:11",
                // ),
                child: QuizResultMessage(
                  categoryLabel: "Sports",
                  isPassed: true,
                  scoreLabel: "10",
                  timeLabel: "00:12",
                  finishedTime: "00:11",
                  ),

                  // ShowQuestion()
              ),
            ),
          ),
        ),
      ),
    );
  }
}
