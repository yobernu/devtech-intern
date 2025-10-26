// core/errors/failures.dart
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

// Network failures
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network error occurred']);
}

// Server failures
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error occurred']);
}

// Cache failures
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error occurred']);
}

// Specific domain failures
class TaskNotFoundFailure extends Failure {
  final String taskId;

  const TaskNotFoundFailure(this.taskId) : super('Task $taskId not found');

  @override
  List<Object?> get props => [taskId, message];
}

class InvalidTaskFailure extends Failure {
  const InvalidTaskFailure([super.message = 'Invalid task data']);
}
