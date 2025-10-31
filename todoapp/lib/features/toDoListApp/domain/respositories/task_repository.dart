import 'package:dartz/dartz.dart';
import 'package:todoapp/core/errors/failures.dart';
import 'package:todoapp/features/toDoListApp/domain/entity/task_entity.dart';

abstract class TaskRepository {
  Future<Either<Failure, void>> addTask(TaskEntity task);

  Future<Either<Failure, void>> updateTask(TaskEntity task);

  Future<Either<Failure, void>> deleteTask(String taskId);

  Future<Either<Failure, List<TaskEntity>>> getTasks();
  Future<Either<Failure, List<TaskEntity>>> getCompletedTasks();
}
