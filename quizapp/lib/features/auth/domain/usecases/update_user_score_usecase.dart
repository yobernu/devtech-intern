import 'package:dartz/dartz.dart';
import 'package:quizapp/core/errors/failures.dart';
import 'package:quizapp/core/usecases.dart';
import 'package:quizapp/features/auth/domain/repositories/user_repositories.dart';

class UpdateUserScoreParams extends Params {
  final int score;

  const UpdateUserScoreParams({required this.score});

  @override
  List<Object?> get props => [score];
}

class UpdateUserScoreUseCase extends UseCase<Unit, UpdateUserScoreParams> {
  final UserRepository repository;

  UpdateUserScoreUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(UpdateUserScoreParams params) async {
    return await repository.updateUserScore(params.score);
  }
}
