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
      if (await networkInfo.isConnected) {
        await remoteDataSource.addTask(task);
        await localDataSource.cacheTasks([task]);
      } else {
        await localDataSource.cacheTasks([task]);
      }
      return const Right(null);
    } catch (e) {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String taskId) async {
    try {
      if (await networkInfo.isConnected) {
        await remoteDataSource.deleteTask(taskId);
      } else {
        await localDataSource.deleteCachedTask(taskId);
      }
      return const Right(null);
    } catch (e) {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasks() async {
    try {
      if (await networkInfo.isConnected) {
        final remoteResult = await remoteDataSource.getTasks();

        return await remoteResult.fold((failure) async => Left(failure), (
          tasks,
        ) async {
          await localDataSource.cacheTasks(tasks);
          return Right(tasks);
        });
      } else {
        final localResult = await localDataSource.getCachedTasks();
        return localResult;
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateTask(TaskEntity task) async {
    try {
      if (await networkInfo.isConnected) {
        await remoteDataSource.updateTask(task);
      } else {
        await localDataSource.updateCachedTask(task);
      }
      return const Right(null);
    } catch (e) {
      return Left(NetworkFailure());
    }
  }
}
