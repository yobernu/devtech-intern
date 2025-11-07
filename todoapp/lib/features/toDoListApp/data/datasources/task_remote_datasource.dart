import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:todoapp/core/constants/firebase_services.dart';
import 'package:todoapp/core/errors/failures.dart';
import 'package:todoapp/features/toDoListApp/domain/entity/task_entity.dart';

abstract class TaskRemoteDatasource {
  Future<Either<Failure, void>> addTask(TaskEntity task);

  Future<Either<Failure, void>> updateTask(TaskEntity task);

  Future<Either<Failure, void>> deleteTask(String taskId);

  Future<Either<Failure, List<TaskEntity>>> getTasks();

  Future<Either<Failure, List<TaskEntity>>> getCompletedTasks();
}

class TaskRemoteDatasourceImpl implements TaskRemoteDatasource {
  final FirebaseService firebase;

  TaskRemoteDatasourceImpl({required this.firebase});

  @override
  Future<Either<Failure, void>> addTask(TaskEntity task) async {
    try {
      await firebase.tasksCollection.add(task.toJson());
      return right(null);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateTask(TaskEntity task) async {
    try {
      await firebase.tasksCollection.doc(task.id).update(task.toJson());
      return right(null);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String taskId) async {
    try {
      await firebase.tasksCollection.doc(taskId).delete();
      return right(null);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasks() async {
    try {
      final snapshot = await firebase.tasksCollection.get();

      final tasks = snapshot.docs.map((doc) {
        final rawData = doc.data();
        if (rawData is Map<String, dynamic>) {
          // ✅ Safe spread (non-null)
          return TaskEntity.fromJson({...rawData, 'id': doc.id});
        } else {
          return TaskEntity(
            id: doc.id,
            title: '',
            description: '',
            isCompleted: false,
            createdAt: DateTime.now(),
            category: '',
          );
        }
      }).toList();

      return Right(tasks);
    } catch (e) {
      print('❌ Remote fetch error: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> getCompletedTasks() async {
    try {
      final snapshot = await firebase.tasksCollection
          .where('isCompleted', isEqualTo: true)
          .get();

      final tasks = snapshot.docs.map((doc) {
        final rawData = doc.data();
        if (rawData is Map<String, dynamic>) {
          // ✅ Safe spread (non-null)
          return TaskEntity.fromJson({...rawData, 'id': doc.id});
        } else {
          return TaskEntity(
            id: doc.id,
            title: '',
            description: '',
            isCompleted: false,
            createdAt: DateTime.now(),
            category: '',
          );
        }
      }).toList();

      return Right(tasks);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
