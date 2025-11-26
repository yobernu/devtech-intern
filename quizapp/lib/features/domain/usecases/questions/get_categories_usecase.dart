import 'package:quizapp/core/errors/failures.dart';
import 'package:quizapp/core/usecases.dart';
import 'package:dartz/dartz.dart';
import 'package:quizapp/features/domain/entities/quiz_category_entity.dart';
import 'package:quizapp/features/domain/repositories/repositories.dart';

class GetCategoriesParams extends NoParams {
  const GetCategoriesParams();
}

class GetCategoriesUsecase
    extends UseCase<List<QuizCategory>, GetCategoriesParams> {
  final CategoriesRepository repository;

  GetCategoriesUsecase(this.repository);

  @override
  Future<Either<Failure, List<QuizCategory>>> call(
    GetCategoriesParams params,
  ) async {
    return await repository.getCategories();
  }
}
