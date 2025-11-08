import 'package:flutter/material.dart';
import 'package:quizapp/core/constants/appcolors.dart';
import 'package:quizapp/features/presentation/widgets/cards/small_actions_button.dart';
import 'package:quizapp/features/presentation/widgets/quiz_option_tiles.dart';

// --- MAIN SCREEN UI (No Logic) ---
class ShowQuestionScreen extends StatelessWidget {
  const ShowQuestionScreen({super.key});

  // Mock data to represent the state shown in the image
  final String _questionText =
      'Which soccer team won the FIFA World Cup for the first time Which soccer team won the FIFA World Cup for the first time?';
  final List<Map<String, dynamic>> _options = const [
    {'prefix': 'A', 'text': 'Uruguay', 'isCorrect': true, 'isSelected': false},
    {'prefix': 'B', 'text': 'Brazil', 'isCorrect': false, 'isSelected': false},
    {'prefix': 'C', 'text': 'Italy', 'isCorrect': false, 'isSelected': false},
    {'prefix': 'D', 'text': 'Germany', 'isCorrect': false, 'isSelected': false},
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        // Back Button
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: AppColors.darkText,
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                AppColors.surfaceWhite.withOpacity(0.8),
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            onPressed: () {}, // No logic
          ),
        ),
        // Title Container (Question Number)
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surfaceWhite.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Question 3/10',
            style: TextStyle(
              color: AppColors.surfaceWhite,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        // Bookmark Button
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            color: AppColors.darkText,
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                AppColors.surfaceWhite.withOpacity(0.8),
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            onPressed: () {}, // No logic
          ),
          const SizedBox(width: 16),
        ],
      ),

      body: SizedBox.expand(
        child: Container(
          // Background Gradient
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryPurple, AppColors.lightSurface],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                height: size.height * 0.8,
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

                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            const Color.fromARGB(
                              255,
                              102,
                              84,
                              193,
                            ).withValues(alpha: 0.25),
                            const Color.fromARGB(255, 255, 255, 255),
                          ],
                          center: Alignment.center,
                          radius: 0.95,
                          focal: Alignment.topCenter,
                          focalRadius: 0.3,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.darkText.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Text(
                        _questionText,
                        style: const TextStyle(
                          color: AppColors.darkText,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // --- Time and Progress Bar ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Time',
                          style: TextStyle(
                            color: AppColors.darkText,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: 0.3,
                              color: AppColors.accentOrange,
                              backgroundColor: AppColors.accentOrange
                                  .withValues(alpha: 0.3),
                              minHeight: 10,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '00:12',
                          style: TextStyle(
                            color: AppColors.darkText,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // --- Answer Options List ---
                    ..._options.map((option) {
                      return QuizOptionTile(
                        optionText: option['text'],
                        prefix: option['prefix'],
                        isCorrectAnswer: option['isCorrect'],
                        isSelected: option['isSelected'],
                      );
                    }).toList(),

                    Spacer(),

                    // --- Action Buttons Row ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SmallActionButton(
                          icon: Icons.person_add_alt_1,
                          label: '50/50',
                          color: AppColors.accentOrange,
                        ),
                        SmallActionButton(
                          icon: Icons.people_alt,
                          label: 'Audience',
                          color: AppColors.accentOrange,
                        ),
                        SmallActionButton(
                          icon: Icons.timer,
                          label: 'Add Time',
                          color: AppColors.accentOrange,
                        ),
                        SmallActionButton(
                          icon: Icons.skip_next,
                          label: 'Skip',
                          color: AppColors.accentOrange,
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
