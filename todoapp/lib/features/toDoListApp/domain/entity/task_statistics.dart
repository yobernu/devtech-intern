class TaskStatistics {
  final int totalTasks;
  final int completedTasks;
  final int overdueTasks;
  final Map<String, int> tasksByCategory;
  final Map<String, int> tasksByPriority;

  TaskStatistics({
    required this.totalTasks,
    required this.completedTasks,
    required this.overdueTasks,
    required this.tasksByCategory,
    required this.tasksByPriority,
  });

  double get completionRate => totalTasks > 0 ? completedTasks / totalTasks : 0;
  int get completionPercentage => (completionRate * 100).toInt();
}
