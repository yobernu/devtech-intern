import 'package:quizapp/core/errors/failures.dart';
import 'package:quizapp/features/domain/entities/question_entity.dart';
import 'package:quizapp/features/domain/entities/quiz_category_entity.dart';

abstract class QuestionsState {}

class QuestionsInitialState extends QuestionsState {}

class QuestionsLoadingState extends QuestionsState {}

class QuestionsLoadedState extends QuestionsState {
  final List<Question> questions;
  final int currentQuestionIndex;
  final int timeLength;
  final int score;
  final int totalTimeTaken;

  QuestionsLoadedState({
    required this.questions,
    required this.currentQuestionIndex,
    required this.timeLength,
    this.score = 0,
    this.totalTimeTaken = 0,
  });

  @override
  List<Object> get props => [
    questions,
    currentQuestionIndex,
    timeLength,
    score,
    totalTimeTaken,
  ];
}

class CurrentQuestionHintState extends QuestionsState {
  final String hint;

  CurrentQuestionHintState(this.hint);

  @override
  List<Object?> get props => [hint];
}

class QuizResultsState extends QuestionsState {
  final int score;
  final int totalQuestions;
  final List<Question> attemptedQuestions;
  final int totalTimeTaken;

  QuizResultsState({
    required this.score,
    required this.totalQuestions,
    required this.attemptedQuestions,
    required this.totalTimeTaken,
  });

  @override
  List<Object> get props => [
    score,
    totalQuestions,
    attemptedQuestions,
    totalTimeTaken,
  ];
}

class QuestionsFailureState extends QuestionsState {
  final Failure failure;

  QuestionsFailureState(this.failure);
}
