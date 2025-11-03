import 'package:dartz/dartz.dart';
import 'package:todoapp/core/errors/failures.dart';
import 'package:todoapp/core/network_info.dart';
import 'package:todoapp/features/toDoListApp/data/datasources/task_remote_datasource.dart';
import 'package:todoapp/features/toDoListApp/data/datasources/tasks_local_datasource.dart';
import 'package:todoapp/features/toDoListApp/domain/entity/task_entity.dart';
import 'package:todoapp/features/toDoListApp/domain/respositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDatasource remoteDataSource;
  final TaskLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  TaskRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, void>> addTask(TaskEntity task) async {
    try {
      await localDataSource.addOrUpdateTask(task);

      if (await networkInfo.isConnected) {
        try {
          await remoteDataSource.addTask(task);
          await _markTaskAsSynced(task.id);
        } catch (e) {
          await _markTaskForSync(task);
        }
      } else {
        await _markTaskForSync(task);
      }

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String taskId) async {
    try {
      await localDataSource.deleteTask(taskId);

      if (await networkInfo.isConnected) {
        try {
          await remoteDataSource.deleteTask(taskId);
        } catch (e) {
          await _markDeletionForSync(taskId);
        }
      } else {
        await _markDeletionForSync(taskId);
      }

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasks() async {
    try {
      if (await networkInfo.isConnected) {
        final remoteResult = await remoteDataSource.getTasks();
        return await remoteResult.fold(
          (failure) async {
            final localTasks = await localDataSource.getCachedTasks();
            return Right(localTasks);
          },
          (tasks) async {
            await localDataSource.cacheAllTasks(tasks);
            return Right(tasks);
          },
        );
      } else {
        final localTasks = await localDataSource.getCachedTasks();
        return Right(localTasks);
      }
    } catch (e) {
      try {
        final localTasks = await localDataSource.getCachedTasks();
        return Right(localTasks);
      } catch (cacheError) {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, void>> updateTask(TaskEntity task) async {
    try {
      await localDataSource.addOrUpdateTask(task);

      if (await networkInfo.isConnected) {
        try {
          await remoteDataSource.updateTask(task);
          await _markTaskAsSynced(task.id);
        } catch (e) {
          await _markTaskForSync(task);
        }
      } else {
        await _markTaskForSync(task);
      }

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> getCompletedTasks() async {
    try {
      final allTasks = await getTasks();
      return allTasks.fold((failure) => Left(failure), (tasks) {
        final completedTasks = tasks.where((task) => task.isCompleted).toList();
        return Right(completedTasks);
      });
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> getPendingTasks() async {
    try {
      final allTasks = await getTasks();
      return allTasks.fold((failure) => Left(failure), (tasks) {
        final pendingTasks = tasks.where((task) => !task.isCompleted).toList();
        return Right(pendingTasks);
      });
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  Future<void> _markTaskForSync(TaskEntity task) async {
    try {
      final taskWithSyncFlag = task.copyWith();
      await localDataSource.addOrUpdateTask(taskWithSyncFlag);
    } catch (e) {
      print('Failed to mark task for sync: $e');
    }
  }

  Future<void> _markTaskAsSynced(String taskId) async {
    try {
      final tasks = await localDataSource.getCachedTasks();
      final task = tasks.firstWhere((t) => t.id == taskId);
      final syncedTask = task.copyWith();
      await localDataSource.addOrUpdateTask(syncedTask);
    } catch (e) {
      print('Failed to mark task as synced: $e');
    }
  }

  Future<void> _markDeletionForSync(String taskId) async {
    try {} catch (e) {
      print('Failed to mark deletion for sync: $e');
    }
  }

  Future<void> syncPendingTasks() async {
    if (await networkInfo.isConnected) {
      try {
        final pendingTasks = await localDataSource.getPendingSyncTasks();
        for (final task in pendingTasks) {
          try {
            await remoteDataSource.addTask(task);
            await _markTaskAsSynced(task.id);
          } catch (e) {
            print('Failed to sync task ${task.id}: $e');
          }
        }
      } catch (e) {
        print('Background sync failed: $e');
      }
    }
  }

  Future<Either<Failure, void>> clearCache() async {
    try {
      await localDataSource.clearCache();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
