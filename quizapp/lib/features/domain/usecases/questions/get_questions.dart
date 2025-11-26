import 'package:quizapp/core/errors/failures.dart';
import 'package:quizapp/core/usecases.dart';
import 'package:dartz/dartz.dart';
import 'package:quizapp/features/domain/entities/question_entity.dart';
import 'package:quizapp/features/domain/repositories/repositories.dart';

class GetQuestionsByIdParams extends Params {
  final String categoryId;
  final Difficulty difficulty;

  const GetQuestionsByIdParams({
    required this.categoryId,
    required this.difficulty,
  });

  @override
  List<Object?> get props => [categoryId, difficulty];
}

class GetQuestionsByIdUsecase
    extends UseCase<List<Question>, GetQuestionsByIdParams> {
  final QuizRepository repository;

  GetQuestionsByIdUsecase(this.repository);

  @override
  Future<Either<Failure, List<Question>>> call(
    GetQuestionsByIdParams params,
  ) async {
    return await repository.getQuestions(params.categoryId, params.difficulty);
  }
}

class GetAllQuestionsUseCase extends UseCase<List<Question>, NoParams> {
  final QuizRepository repository;

  GetAllQuestionsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Question>>> call(NoParams params) async {
    return await repository.getAllQuestions();
  }
}
