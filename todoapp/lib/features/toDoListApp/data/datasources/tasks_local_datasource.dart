import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:todoapp/core/errors/failures.dart';
import 'package:todoapp/features/toDoListApp/domain/entity/task_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class TaskLocalDataSource {
  Future<Either<Failure, void>> cacheTasks(List<TaskEntity> tasks);

  Future<Either<Failure, void>> updateCachedTask(TaskEntity task);

  Future<Either<Failure, void>> deleteCachedTask(String taskId);

  Future<Either<Failure, List<TaskEntity>>> getCachedTasks();
}

const String cachedTasksKey = 'CACHED_TASKS';

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  @override
  Future<Either<Failure, void>> cacheTasks(List<TaskEntity> tasks) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentTasks = await getCachedTasks();
      final updatedTasks = [...currentTasks.getOrElse(() => []), ...tasks];
      final encoded = jsonEncode(updatedTasks.map((t) => t.toJson()).toList());
      await prefs.setString(cachedTasksKey, encoded);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateCachedTask(TaskEntity task) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasks = await getCachedTasks();
      final currentTasks = tasks.getOrElse(() => []);
      final updatedTasks = currentTasks
          .map((t) => t.id == task.id ? task : t)
          .toList();
      final encoded = jsonEncode(updatedTasks.map((t) => t.toJson()).toList());
      await prefs.setString(cachedTasksKey, encoded);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteCachedTask(String taskId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasks = await getCachedTasks();
      final currentTasks = tasks.getOrElse(() => []);
      final updatedTasks = currentTasks.where((t) => t.id != taskId).toList();
      final encoded = jsonEncode(updatedTasks.map((t) => t.toJson()).toList());
      await prefs.setString(cachedTasksKey, encoded);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> getCachedTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(cachedTasksKey);
      if (jsonString != null) {
        final decoded = jsonDecode(jsonString) as List;
        final tasks = decoded.map((e) => TaskEntity.fromJson(e)).toList();
        return Right(tasks);
      } else {
        return Right([]);
      }
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
