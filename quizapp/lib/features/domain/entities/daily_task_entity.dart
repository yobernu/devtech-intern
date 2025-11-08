class DailyTask {
  final String id;
  final String title;
  final String description;
  final int totalQuestions;
  final int completedQuestions;
  final DateTime date;
  final List<String> categoryIds;
  final TaskStatus status;
  final int rewardPoints;

  DailyTask({
    required this.id,
    required this.title,
    required this.description,
    required this.totalQuestions,
    required this.completedQuestions,
    required this.date,
    required this.categoryIds,
    required this.status,
    required this.rewardPoints,
  });
}

enum TaskStatus { locked, available, inProgress, completed }
