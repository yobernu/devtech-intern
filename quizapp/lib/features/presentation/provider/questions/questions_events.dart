import 'package:equatable/equatable.dart';
import 'package:quizapp/features/domain/entities/question_entity.dart';

abstract class QuestionsEvent extends Equatable {
  const QuestionsEvent();

  @override
  List<Object?> get props => [];
}

// Fetch all questions (maybe random or default)
class GetQuestionsEvent extends QuestionsEvent {
  const GetQuestionsEvent();
}

// Fetch questions by category and difficulty
class GetQuestionsByCategoryEvent extends QuestionsEvent {
  final String categoryId;
  final Difficulty difficulty;

  const GetQuestionsByCategoryEvent({
    required this.categoryId,
    required this.difficulty,
  });

  @override
  List<Object?> get props => [categoryId, difficulty];
}

class CurrentQuestionHintEvent extends QuestionsEvent {
  final String hint;

  const CurrentQuestionHintEvent(this.hint);

  @override
  List<Object?> get props => [hint];
}

class NextQuestionEvent extends QuestionsEvent {
  final int currentIndex;
  final bool isCorrect;
  final int timeTaken;

  const NextQuestionEvent(
    this.currentIndex, {
    this.isCorrect = false,
    this.timeTaken = 0,
  });

  @override
  List<Object> get props => [currentIndex, isCorrect, timeTaken];
}
