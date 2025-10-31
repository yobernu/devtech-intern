import 'package:flutter/material.dart';
import 'package:todoapp/core/errors/failures.dart';
import 'package:todoapp/core/usecases.dart';
import 'package:todoapp/features/toDoListApp/domain/entity/task_entity.dart';
import 'package:todoapp/features/toDoListApp/domain/usecase/add_task.dart';
import 'package:todoapp/features/toDoListApp/domain/usecase/get_task.dart';
import 'package:todoapp/features/toDoListApp/domain/usecase/update_task.dart';
import 'package:todoapp/features/toDoListApp/domain/usecase/delete_task.dart';

class TaskProvider extends ChangeNotifier {
  final AddTask addTask;
  final GetTasks getTasks;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;

  TaskProvider({
    required this.addTask,
    required this.getTasks,
    required this.updateTask,
    required this.deleteTask,
  });

  bool isLoading = false;
  String? errorMessage;
  List<TaskEntity> tasks = [];

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
