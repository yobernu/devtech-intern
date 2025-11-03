import 'dart:convert';
import 'package:todoapp/core/errors/exceptions.dart';
import 'package:todoapp/core/errors/failures.dart';
import 'package:todoapp/features/toDoListApp/domain/entity/task_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskEntity>> getCachedTasks();
  Future<void> cacheAllTasks(List<TaskEntity> tasks);
  Future<void> addOrUpdateTask(TaskEntity task);
  Future<void> deleteTask(String taskId);
  Future<void> markTaskAsSynced(String taskId);
  Future<List<TaskEntity>> getPendingSyncTasks();
  Future<void> clearCache();
}

const String cachedTasksKey = 'CACHED_TASKS';
const String lastSyncKey = 'LAST_SYNC_TIMESTAMP';

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  @override
  Future<List<TaskEntity>> getCachedTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(cachedTasksKey);
      if (jsonString != null) {
        final decoded = jsonDecode(jsonString) as List;
        return decoded.map((e) => TaskEntity.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheAllTasks(List<TaskEntity> tasks) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(tasks.map((t) => t.toJson()).toList());
      await prefs.setString(cachedTasksKey, encoded);
      await prefs.setString(lastSyncKey, DateTime.now().toIso8601String());
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> addOrUpdateTask(TaskEntity task) async {
    try {
      final currentTasks = await getCachedTasks();

      final filteredTasks = currentTasks.where((t) => t.id != task.id).toList();

      final updatedTasks = [...filteredTasks, task];

      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(updatedTasks.map((t) => t.toJson()).toList());
      await prefs.setString(cachedTasksKey, encoded);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    try {
      final currentTasks = await getCachedTasks();
      final updatedTasks = currentTasks.where((t) => t.id != taskId).toList();

      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(updatedTasks.map((t) => t.toJson()).toList());
      await prefs.setString(cachedTasksKey, encoded);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> markTaskAsSynced(String taskId) async {
    try {
      final currentTasks = await getCachedTasks();
      final updatedTasks = currentTasks.map((task) {
        if (task.id == taskId) {
          return task.copyWith(updatedAt: DateTime.now());
        }
        return task;
      }).toList();

      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(updatedTasks.map((t) => t.toJson()).toList());
      await prefs.setString(cachedTasksKey, encoded);
      await prefs.setString(lastSyncKey, DateTime.now().toIso8601String());
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<List<TaskEntity>> getPendingSyncTasks() async {
    try {
      final tasks = await getCachedTasks();

      return tasks;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(cachedTasksKey);
      await prefs.remove(lastSyncKey);
    } catch (e) {
      throw CacheException();
    }
  }
}
