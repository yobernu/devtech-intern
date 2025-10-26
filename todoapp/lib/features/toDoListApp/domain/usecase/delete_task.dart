import 'package:dartz/dartz.dart';
import 'package:todoapp/core/errors/failures.dart';
import 'package:todoapp/core/usecases.dart';
import 'package:todoapp/features/toDoListApp/domain/entity/task_entity.dart';
import 'package:todoapp/features/toDoListApp/domain/respositories/task_repository.dart';

class DeleteTaskParams extends Params {
  final TaskEntity task;

  const DeleteTaskParams({required this.task});

  @override
  List<Object?> get props => [task];
}

class DeleteTask implements UseCase<void, DeleteTaskParams> {
  final TaskRepository taskRepository;

  const DeleteTask({required this.taskRepository});

  @override
  Future<Either<Failure, void>> call(DeleteTaskParams params) async {
    return await taskRepository.deleteTask(params.task);
  }
}
