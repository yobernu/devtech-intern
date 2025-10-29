import 'package:dartz/dartz.dart';
import 'package:todoapp/core/errors/failures.dart';
import 'package:todoapp/core/usecases.dart';
import 'package:todoapp/features/toDoListApp/domain/respositories/task_repository.dart';

class DeleteTaskParams extends Params {
  final String taskId;
  const DeleteTaskParams({required this.taskId});

  @override
  List<Object?> get props => [taskId];
}

class DeleteTask implements UseCase<void, DeleteTaskParams> {
  final TaskRepository taskRepository;

  const DeleteTask({required this.taskRepository});

  @override
  Future<Either<Failure, void>> call(DeleteTaskParams params) async {
    return await taskRepository.deleteTask(params.taskId);
  }
}
