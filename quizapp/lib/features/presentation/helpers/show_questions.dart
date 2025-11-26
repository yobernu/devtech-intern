import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/core/constants/appcolors.dart';
import 'package:quizapp/features/presentation/helpers/alerts/show_custom_snack_bar.dart';
import 'package:quizapp/features/presentation/helpers/show_questions_body.dart';
import 'package:quizapp/features/presentation/provider/questions/questions_bloc.dart';
import 'package:quizapp/features/presentation/provider/questions/questions_events.dart';
import 'package:quizapp/features/presentation/provider/questions/questions_state.dart';

// attemptedQuestions
class ShowQuestion extends StatefulWidget {
  const ShowQuestion({super.key});

  @override
  State<ShowQuestion> createState() => _ShowQuestionState();
}

class _ShowQuestionState extends State<ShowQuestion> {
  int? _selectedOptionIndex;
  int _lastQuestionIndex = -1;

  final Set<int> _hiddenOptionIndices = {};
  bool _is5050Used = false;
  bool _isAudienceUsed = false;
  bool _isHintUsed = false;

  void _nextQuestion(
    BuildContext context,
    int currentIndex,
    bool isCorrect,
    int timeTaken,
  ) {
    context.read<QuestionsBloc>().add(
      NextQuestionEvent(
        currentIndex,
        isCorrect: isCorrect,
        timeTaken: timeTaken,
      ),
    );
  }

  void _onOptionSelected(int index) {
    if (_selectedOptionIndex != null) return;
    setState(() {
      _selectedOptionIndex = index;
    });
  }

  void _handleTimeExpired(
    BuildContext context,
    int currentIndex,
    int timeLimit,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const AlertDialog(
        title: Text("Time's Up!"),
        content: Text("Moving to the next question..."),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        Navigator.of(context).pop(); // Close dialog
        // Time taken is the full time limit since it expired
        _nextQuestion(context, currentIndex, false, timeLimit);
      }
    });
  }

  void _use5050(int correctAnswerIndex, int totalOptions) {
    if (_is5050Used || _selectedOptionIndex != null) return;

    final incorrectIndices = List.generate(
      totalOptions,
      (i) => i,
    ).where((i) => i != correctAnswerIndex).toList();

    incorrectIndices.shuffle();

    setState(() {
      _hiddenOptionIndices.addAll(incorrectIndices.take(2));
      _is5050Used = true;
    });
  }

  void _useAudience(int correctAnswerIndex) {
    if (_isAudienceUsed || _selectedOptionIndex != null) return;

    setState(() {
      _isAudienceUsed = true;
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Audience Poll"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Here is what the audience thinks:"),
              const SizedBox(height: 16),
              // Simple bar chart simulation
              ...List.generate(4, (index) {
                final isCorrect = index == correctAnswerIndex;
                final percentage = isCorrect
                    ? 65
                    : 10 + (index * 2); // Fake data
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Text(String.fromCharCode('A'.codeUnitAt(0) + index)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: percentage / 100,
                          color: isCorrect
                              ? AppColors.correctGreen
                              : AppColors.primaryPurple,
                          backgroundColor: AppColors.primaryPurple.withOpacity(
                            0.1,
                          ),
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text("$percentage%"),
                    ],
                  ),
                );
              }),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void _useHint(String hintText) {
    if (_isHintUsed || _selectedOptionIndex != null) return;

    setState(() {
      _isHintUsed = true;
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Hint"),
          content: Text(
            hintText.isNotEmpty
                ? hintText
                : "No hint available for this question.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Thanks!"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuestionsBloc, QuestionsState>(
      listener: (context, state) {
        if (state is QuestionsFailureState) {
          showSnackbar(
            context,
            'Quiz Fetch Failed: ${state.failure.message}',
            isError: true,
          );
        } else if (state is QuizResultsState) {
          final percentage = (state.score / state.totalQuestions) * 100;
          final isPassed = percentage >= 50;

          Navigator.pushNamed(
            context,
            '/resultScreen',
            arguments: {
              'isPassed': isPassed,
              'scoreLabel': '${state.score}/${state.totalQuestions}',
              'categoryLabel': state.attemptedQuestions.isNotEmpty
                  ? state.attemptedQuestions.first.categoryId
                  : 'General',
              'timeLabel': '${state.totalQuestions * 30}s',
              'finishedTime': '${state.totalTimeTaken}s',
              'attemptedQuestions': state.attemptedQuestions,
            },
          );
        }
      },
      builder: (context, state) {
        if (state is QuestionsLoadingState) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryPurple),
          );
        }

        if (state is QuestionsLoadedState) {
          if (state.questions.isEmpty) {
            return const Center(child: Text('No questions found.'));
          }

          final currentQuestionIndex = state.currentQuestionIndex;

          if (currentQuestionIndex != _lastQuestionIndex) {
            _selectedOptionIndex = null;
            _lastQuestionIndex = currentQuestionIndex;
            _hiddenOptionIndices.clear();
            _is5050Used = false;
            _isAudienceUsed = false;
            _isHintUsed = false;
          }

          final questionsLength = state.questions.length;
          final isLastQuestion = currentQuestionIndex == questionsLength - 1;
          final timeLength = state.timeLength;

          final currentQuestion = state.questions[currentQuestionIndex];

          final optionsData = currentQuestion.options.asMap().entries.map((
            entry,
          ) {
            final index = entry.key;
            final option = entry.value;

            return {
              'text': option.text,
              'prefix': String.fromCharCode('A'.codeUnitAt(0) + index),
              'isCorrect': index == currentQuestion.correctAnswerIndex,
              'isSelected': index == _selectedOptionIndex,
              'isHidden': _hiddenOptionIndices.contains(index),
              'imageUrl': option.imageUrl,
            };
          }).toList();

          return ShowQuestionsBody(
            questionText: currentQuestion.questionText,
            options: optionsData,
            onNextPressed: (remainingTime) {
              final isCorrect =
                  _selectedOptionIndex != null &&
                  _selectedOptionIndex == currentQuestion.correctAnswerIndex;
              final timeTaken = timeLength - remainingTime;

              _nextQuestion(
                context,
                currentQuestionIndex,
                isCorrect,
                timeTaken,
              );
            },
            onOptionSelected: _onOptionSelected,
            onTimeExpired: () =>
                _handleTimeExpired(context, currentQuestionIndex, timeLength),
            isAnswered: _selectedOptionIndex != null,
            isLastQuestion: isLastQuestion,
            currentQuestionNumber: currentQuestionIndex + 1,
            totalQuestions: questionsLength,
            initialTimeLength: timeLength,

            on5050Pressed: () => _use5050(
              currentQuestion.correctAnswerIndex,
              currentQuestion.options.length,
            ),
            onAudiencePressed: () =>
                _useAudience(currentQuestion.correctAnswerIndex),
            onHintPressed: () => _useHint(currentQuestion.hint),
          );
        }

        if (state is QuestionsFailureState) {
          return Center(child: Text('Error: ${state.failure.message}'));
        }

        if (state is QuizResultsState) {
          return const SizedBox.shrink();
        }

        return const Center(child: Text('Select a category to begin.'));
      },
    );
  }
}
