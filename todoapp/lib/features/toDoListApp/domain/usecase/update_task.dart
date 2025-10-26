import 'package:dartz/dartz.dart';
import 'package:todoapp/core/errors/failures.dart';
import 'package:todoapp/core/usecases.dart';
import 'package:todoapp/features/toDoListApp/domain/entity/task_entity.dart';
import 'package:todoapp/features/toDoListApp/domain/respositories/task_repository.dart';

class UpdateTaskParams extends Params {
  final TaskEntity task;

  const UpdateTaskParams({required this.task});

  @override
  List<Object?> get props => [task];
}

class UpdateTask implements UseCase<void, UpdateTaskParams> {
  final TaskRepository taskRepository;

  const UpdateTask({required this.taskRepository});

  @override
  Future<Either<Failure, void>> call(UpdateTaskParams params) async {
    return await taskRepository.updateTask(params.task);
  }
}
