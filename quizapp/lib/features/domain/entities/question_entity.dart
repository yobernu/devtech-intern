class Question {
  final String id;
  final String categoryId;
  final String questionText;
  final QuestionType type;
  final List<AnswerOption> options;
  final int correctAnswerIndex;
  final String explanation;
  final Difficulty difficulty;
  final int timeLimit; // in seconds
  final String? imageUrl;
  final String? audioUrl;

  Question({
    required this.id,
    required this.categoryId,
    required this.questionText,
    required this.type,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
    required this.difficulty,
    required this.timeLimit,
    this.imageUrl,
    this.audioUrl,
  });
}

class AnswerOption {
  final String text;
  final String? imageUrl;

  AnswerOption({required this.text, this.imageUrl});
}

enum QuestionType {
  multipleChoice,
  trueFalse,
  textInput,
  imageSelection,
  audioBased,
}

enum Difficulty { easy, medium, hard, expert }
