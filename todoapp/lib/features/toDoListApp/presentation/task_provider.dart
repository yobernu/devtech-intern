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
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await addTask(AddTaskParams(task: task));

    result.fold((Failure failure) => errorMessage = failure.toString(), (
      _,
    ) async {
      debugPrint('Task created successfully');
      await fetchTasks();
    });

    isLoading = false;
    notifyListeners();
  }

  // FETCH
  Future<void> fetchTasks() async {
    try {
      print('Fetching tasks...');
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final result = await getTasks(NoParams());
      print('Received result from getTasks: $result');

      result.fold(
        (Failure failure) {
          print('Error fetching tasks: ${failure.toString()}');
          errorMessage = failure.toString();
          tasks = [];
        },
        (List<TaskEntity> fetchedTasks) {
          print('Successfully fetched ${fetchedTasks.length} tasks');
          tasks = fetchedTasks;
          if (tasks.isNotEmpty) {
            print('First task: ${tasks.first.title}');
          }
        },
      );
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // UPDATE
  Future<void> updateTaskItem(TaskEntity updatedTask) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await updateTask(UpdateTaskParams(task: updatedTask));

    result.fold((Failure failure) => errorMessage = failure.toString(), (
      _,
    ) async {
      debugPrint('Task updated successfully');
      await fetchTasks();
    });

    isLoading = false;
    notifyListeners();
  }

  // DELETE
  Future<void> deleteTaskItem(String taskId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await deleteTask(DeleteTaskParams(taskId: taskId));

    result.fold((Failure failure) => errorMessage = failure.toString(), (
      _,
    ) async {
      debugPrint('Task deleted successfully');
      await fetchTasks();
    });

    isLoading = false;
    notifyListeners();
  }
}
