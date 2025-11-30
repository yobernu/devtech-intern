import 'package:dartz/dartz.dart';
import 'package:quizapp/core/errors/exceptions.dart'; // Import CacheException
import 'package:quizapp/core/errors/failures.dart';
import 'package:quizapp/core/network_info.dart';
import 'package:quizapp/features/data/datasources/localdatasources/local_categories_datasources.dart'; // <-- New Import
import 'package:quizapp/features/data/datasources/remote_datasource/remote_categories_datasource.dart';
import 'package:quizapp/features/domain/entities/quiz_category_entity.dart';
import 'package:quizapp/features/domain/repositories/repositories.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  final RemoteCategoriesDatasource remoteCategoriesDatasource;
  final LocalCategoriesDatasources
  localCategoriesDatasource; // <-- New Dependency
  final NetworkInfo networkInfo;

  CategoriesRepositoryImpl(
    this.remoteCategoriesDatasource,
    this.localCategoriesDatasource,
    this.networkInfo,
  );

  @override
  Future<Either<Failure, List<QuizCategory>>> getCategories() async {
    try {
      final cachedModels = await localCategoriesDatasource
          .getCachedCategories();
      final entities = cachedModels.map((m) => m.toEntity()).toList();
      return Right(entities);
    } on CacheException {
      print('Cache miss or expired, checking network...');
    }
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return Left(
        NetworkFailure(
          "No internet connection and no categories cache available.",
        ),
      );
    }
    try {
      final models = await remoteCategoriesDatasource.getAllCategories();
      await localCategoriesDatasource.cacheCategories(models);

      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getCategoryNameById(String id) async {
    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return Left(NetworkFailure("No internet connection"));
    }
    try {
      final categoryName = await remoteCategoriesDatasource.getCategoryNameById(
        id,
      );

      if (categoryName == null) {
        return Left(ServerFailure("Category not found with id: $id"));
      }

      return Right(categoryName);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
