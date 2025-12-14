import 'package:flutter/material.dart';
import 'package:todoapp/core/errors/failures.dart';
import 'package:todoapp/core/usecases.dart';
import 'package:todoapp/features/toDoListApp/domain/entity/task_entity.dart';
import 'package:todoapp/features/toDoListApp/domain/usecase/add_task.dart';
import 'package:todoapp/features/toDoListApp/domain/usecase/get_completed_tasks.dart';
import 'package:todoapp/features/toDoListApp/domain/usecase/get_task.dart';
import 'package:todoapp/features/toDoListApp/domain/usecase/update_task.dart';
import 'package:todoapp/features/toDoListApp/domain/usecase/delete_task.dart';
import 'package:todoapp/features/toDoListApp/domain/entity/task_statistics.dart';

class TaskProvider extends ChangeNotifier {
  final AddTask addTask;
  final GetTasks getTasks;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;
  final GetCompletedTasks getCompletedTasks;

  TaskProvider({
    required this.addTask,
    required this.getTasks,
    required this.updateTask,
    required this.deleteTask,
    required this.getCompletedTasks,
  });

  bool isLoading = false;
  String? errorMessage;
  List<TaskEntity> tasks = [];
  List<TaskEntity> completedTasks = [];

  // CREATE
  Future<void> createTask(TaskEntity task) async {
    _setLoading(true);
    final result = await addTask(AddTaskParams(task: task));

    result.fold(
      (Failure failure) {
        _setError(failure.toString());
      },
      (_) async {
        debugPrint('✅ Task created successfully');
        await fetchTasks();
      },
    );

    _setLoading(false);
  }

  // FETCH
  Future<void> fetchTasks() async {
    _setLoading(true);
    debugPrint('📥 Fetching tasks...');

    final result = await getTasks(NoParams());

    result.fold(
      (Failure failure) {
        _setError(failure.toString());
        tasks = [];
      },
      (List<TaskEntity> fetchedTasks) {
        tasks = fetchedTasks;
        debugPrint('✅ Fetched ${tasks.length} tasks');
        if (tasks.isNotEmpty) {
          debugPrint('📝 First task: ${tasks.first.title}');
        }
      },
    );

    _setLoading(false);
  }

  // Fetch completed tasks
  Future<void> fetchCompletedTasks() async {
    _setLoading(true);
    try {
      final result = await getCompletedTasks(NoParams());

      result.fold(
        (Failure failure) {
          _setError(failure.toString());
          completedTasks = [];
        },
        (List<TaskEntity> fetchedTasks) {
          completedTasks = fetchedTasks;
          debugPrint('✅ Fetched ${completedTasks.length} tasks');
          if (completedTasks.isNotEmpty) {
            debugPrint('📝 First task: ${completedTasks.first.title}');
          }
        },
      );
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // UPDATE
  Future<void> updateTaskItem(TaskEntity updatedTask) async {
    _setLoading(true);

    final result = await updateTask(UpdateTaskParams(task: updatedTask));

    result.fold((Failure failure) => _setError(failure.toString()), (_) async {
      debugPrint('🔁 Task updated successfully');
      await fetchTasks();
    });

    _setLoading(false);
  }

  // DELETE
  Future<void> deleteTaskItem(String taskId) async {
    _setLoading(true);

    final result = await deleteTask(DeleteTaskParams(taskId: taskId));

    result.fold((Failure failure) => _setError(failure.toString()), (_) async {
      debugPrint('🗑️ Task deleted successfully');
      await fetchTasks();
    });

    _setLoading(false);
  }

  // Filtering & Sorting
  String _searchQuery = '';
  String? _categoryFilter;
  String? _priorityFilter;
  String _currentTab = 'All'; // All, Active, Completed

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategoryFilter(String? category) {
    if (_categoryFilter == category) {
      _categoryFilter = null; // Toggle off
    } else {
      _categoryFilter = category;
    }
    notifyListeners();
  }

  void setPriorityFilter(String? priority) {
    if (_priorityFilter == priority) {
      _priorityFilter = null; // Toggle off
    } else {
      _priorityFilter = priority;
    }
    notifyListeners();
  }

  void setTab(String tab) {
    _currentTab = tab;
    notifyListeners();
  }

  List<TaskEntity> get filteredTasks {
    return tasks.where((task) {
      // Tab filter
      if (_currentTab == 'Active' && task.isCompleted) return false;
      if (_currentTab == 'Completed' && !task.isCompleted) return false;

      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesTitle = task.title.toLowerCase().contains(query);
        final matchesDesc =
            task.description?.toLowerCase().contains(query) ?? false;
        if (!matchesTitle && !matchesDesc) return false;
      }

      // Category filter
      if (_categoryFilter != null && task.category != _categoryFilter) {
        return false;
      }

      // Priority filter
      if (_priorityFilter != null && task.priority != _priorityFilter) {
        return false;
      }

      return true;
    }).toList();
  }

  TaskStatistics get statistics {
    int completed = 0;
    int overdue = 0;
    final byCategory = <String, int>{};
    final byPriority = <String, int>{};

    final now = DateTime.now();

    for (final task in tasks) {
      if (task.isCompleted) completed++;

      if (!task.isCompleted &&
          task.dueDate != null &&
          task.dueDate!.isBefore(now)) {
        overdue++;
      }

      byCategory[task.category] = (byCategory[task.category] ?? 0) + 1;
      byPriority[task.priority] = (byPriority[task.priority] ?? 0) + 1;
    }

    return TaskStatistics(
      totalTasks: tasks.length,
      completedTasks: completed,
      overdueTasks: overdue,
      tasksByCategory: byCategory,
      tasksByPriority: byPriority,
    );
  }

  // Helper methods
  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    errorMessage = message;
    debugPrint('❌ Error: $message');
    notifyListeners();
  }
}

// Future<void> clearError() async {
//   await errorMessage = "";
// }
