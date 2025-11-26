import 'package:dartz/dartz.dart';
import 'package:quizapp/core/errors/failures.dart';
import 'package:quizapp/core/usecases.dart';
import 'package:quizapp/features/domain/repositories/repositories.dart';

class GetCategoryNameByIdParams extends Params {
  final String id;

  const GetCategoryNameByIdParams({required this.id});

  @override
  List<Object?> get props => [id];
}

class GetCategoryNameByIdUsecase
    extends UseCase<String, GetCategoryNameByIdParams> {
  final CategoriesRepository repository;

  GetCategoryNameByIdUsecase(this.repository);

  @override
  Future<Either<Failure, String>> call(GetCategoryNameByIdParams params) async {
    return await repository.getCategoryNameById(params.id);
  }
}
