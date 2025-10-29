import 'package:dartz/dartz.dart';
import 'package:todoapp/core/errors/failures.dart';
import 'package:todoapp/core/usecases.dart';
import 'package:todoapp/features/toDoListApp/domain/entity/task_entity.dart';
import 'package:todoapp/features/toDoListApp/domain/respositories/task_repository.dart';

class GetTasks implements UseCase<List<TaskEntity>, NoParams> {
  final TaskRepository taskRepository;

  GetTasks({required this.taskRepository});

  @override
  Future<Either<Failure, List<TaskEntity>>> call(NoParams params) {
    return taskRepository.getTasks();
  }
}
