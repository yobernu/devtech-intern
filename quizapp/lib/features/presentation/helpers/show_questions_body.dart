import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quizapp/core/constants/appcolors.dart';
import 'package:quizapp/features/presentation/widgets/cards/small_actions_button.dart';
import 'package:quizapp/features/presentation/widgets/quiz_option_tiles.dart';

class ShowQuestionsBody extends StatefulWidget {
  final String questionText;
  final List<Map<String, dynamic>> options;
  final Function(int) onNextPressed;
  final Function(int) onOptionSelected;
  final VoidCallback onTimeExpired;
  final bool isAnswered;
  final bool isLastQuestion;
  final int currentQuestionNumber;
  final int totalQuestions;
  final int initialTimeLength;

  // Lifeline callbacks
  final VoidCallback on5050Pressed;
  final VoidCallback onAudiencePressed;
  final VoidCallback onHintPressed;

  const ShowQuestionsBody({
    super.key,
    required this.questionText,
    required this.options,
    required this.onNextPressed,
    required this.onOptionSelected,
    required this.onTimeExpired,
    required this.isAnswered,
    required this.isLastQuestion,
    required this.currentQuestionNumber,
    required this.totalQuestions,
    required this.initialTimeLength,
    required this.on5050Pressed,
    required this.onAudiencePressed,
    required this.onHintPressed,
  });

  @override
  State<ShowQuestionsBody> createState() => _ShowQuestionsBodyState();
}

class _ShowQuestionsBodyState extends State<ShowQuestionsBody> {
  late int _currentTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _currentTime = widget.initialTimeLength;
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant ShowQuestionsBody oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If question changed, timer resets
    if (widget.initialTimeLength != oldWidget.initialTimeLength ||
        widget.currentQuestionNumber != oldWidget.currentQuestionNumber) {
      _timer?.cancel();
      _currentTime = widget.initialTimeLength;
      _startTimer();
    }

    // If answered, timer stops
    if (widget.isAnswered && !oldWidget.isAnswered) {
      _timer?.cancel();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentTime > 0) {
        setState(() {
          _currentTime--;
        });
      } else {
        timer.cancel();
        widget.onTimeExpired();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            width: double.infinity,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWhite,
                    gradient: RadialGradient(
                      colors: [
                        const Color.fromARGB(
                          255,
                          102,
                          84,
                          193,
                        ).withOpacity(0.25),
                        AppColors.surfaceWhite,
                      ],
                      radius: 0.15,
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
                    widget.questionText,
                    style: const TextStyle(
                      color: AppColors.darkText,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                Positioned(
                  right: 10,
                  top: 10,
                  child: Row(
                    children: [
                      Text(_currentTime.toString()),
                      const SizedBox(width: 8),
                      const Icon(Icons.timer),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          Row(
            children: [
              const Text("rem"),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: widget.currentQuestionNumber / widget.totalQuestions,
                    color: AppColors.accentOrange,
                    backgroundColor: AppColors.accentOrange.withOpacity(0.3),
                    minHeight: 10,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text('${widget.currentQuestionNumber}/${widget.totalQuestions}'),
            ],
          ),

          const SizedBox(height: 24),
          ...widget.options.asMap().entries.map((entry) {
            final index = entry.key;
            final opt = entry.value;
            return QuizOptionTile(
              optionText: opt['text'],
              prefix: opt['prefix'],
              isCorrectAnswer: opt['isCorrect'],
              isSelected: opt['isSelected'],
              isHidden: opt['isHidden'] ?? false,
              onTap: () => widget.onOptionSelected(index),
            );
          }),

          const SizedBox(height: 32),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SmallActionButton(
                  icon: Icons.person_add_alt_1,
                  label: '50/50',
                  color: AppColors.primaryPurple,
                  onPress: widget.on5050Pressed,
                ),
                const SizedBox(width: 12),
                SmallActionButton(
                  icon: Icons.people_alt,
                  label: 'Audience',
                  color: AppColors.smallButtonRed,
                  onPress: widget.onAudiencePressed,
                ),
                const SizedBox(width: 12),
                SmallActionButton(
                  icon: widget.isLastQuestion
                      ? Icons.check
                      : Icons.arrow_forward_ios,
                  label: widget.isLastQuestion ? 'FINISH' : 'NEXT',
                  color: AppColors.smallButtonTeal,
                  onPress: () => widget.onNextPressed(_currentTime),
                ),
                const SizedBox(width: 12),
                SmallActionButton(
                  icon: Icons.lightbulb,
                  label: 'Hint',
                  color: AppColors.smallButtonYellow,
                  onPress: widget.onHintPressed,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
