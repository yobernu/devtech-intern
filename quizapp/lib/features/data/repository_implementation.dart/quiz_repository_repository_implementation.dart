import 'package:dartz/dartz.dart';
import 'package:quizapp/core/errors/exceptions.dart';
import 'package:quizapp/core/errors/failures.dart';
import 'package:quizapp/features/data/datasources/localdatasources/local_categories_datasources.dart'; // <-- Used
import 'package:quizapp/features/data/datasources/localdatasources/local_quiz_datasources.dart'; // <-- Used
import 'package:quizapp/features/data/datasources/remote_datasource/remote_quiz_repository_datasource.dart';
import 'package:quizapp/features/domain/entities/question_entity.dart';
import 'package:quizapp/features/domain/entities/quiz_category_entity.dart';
import 'package:quizapp/features/domain/repositories/repositories.dart';
import 'package:quizapp/core/network_info.dart';

class QuizRepositoryImpl implements QuizRepository {
  final RemoteQuizDataSource remoteDataSource;
  final LocalQuizDatasources localQuizDataSource;
  final NetworkInfo networkInfo;

  QuizRepositoryImpl(
    this.remoteDataSource,
    this.localQuizDataSource,
    this.networkInfo,
  );

  @override
  Future<Either<Failure, List<Question>>> getQuestions(
    String categoryId,
    Difficulty difficulty,
  ) async {
    final isConnected = await networkInfo.isConnected;
    final difficultyName = difficulty.toString().split('.').last;

    if (isConnected) {
      try {
        final models = await remoteDataSource.getQuestions(
          categoryId,
          difficultyName,
        );
        await localQuizDataSource.cacheQuestions(models);

        final entities = models.map((m) => m.toEntity()).toList();
        return Right(entities);
      } catch (e) {
        CacheException('Network failed, falling back to cache...');
      }
    }
    try {
      final cachedModels = await localQuizDataSource.getCachedQuestions();
      final entities = cachedModels.map((m) => m.toEntity()).toList();
      return Right(entities);
    } on CacheException {
      if (isConnected == false) {
        return Left(NetworkFailure('No internet connection.'));
      } else {
        return Left(ServerFailure('Network failed and no cache data found.'));
      }
    }
  }

  @override
  Future<Either<Failure, List<Question>>> getAllQuestions() {
    // TODO: implement getAllQuestions
    throw UnimplementedError();
  }
}
