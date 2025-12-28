import 'package:dartz/dartz.dart';
import 'package:quizapp/core/errors/failures.dart';
import 'package:quizapp/core/usecases.dart';
import 'package:quizapp/features/domain/repositories/repositories.dart';

class GetUserScoreParams extends Params {
  const GetUserScoreParams();

  @override
  List<Object?> get props => [];
}

class GetUserScoreUseCase extends UseCase<int, GetUserScoreParams> {
  final QuizRepository repository;

  GetUserScoreUseCase(this.repository);

  @override
  Future<Either<Failure, int>> call(GetUserScoreParams params) async {
    try {
      final score = await repository.getUserScore();
      return Right(score);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
