import 'package:dartz/dartz.dart';
import 'package:todoapp/core/errors/failures.dart';
import 'package:todoapp/core/usecases.dart';
import 'package:todoapp/features/toDoListApp/domain/entity/task_entity.dart';
import 'package:todoapp/features/toDoListApp/domain/respositories/task_repository.dart';

class AddTaskParams extends Params {
  final TaskEntity task;

  const AddTaskParams({required this.task});

  @override
  List<Object?> get props => [task];
}

class AddTask implements UseCase<void, AddTaskParams> {
  final TaskRepository taskRepository;

  AddTask({required this.taskRepository});

  @override
  Future<Either<Failure, void>> call(AddTaskParams params) {
    return taskRepository.addTask(params.task);
  }
}
