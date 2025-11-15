import 'package:dartz/dartz.dart';
import 'package:quizapp/core/errors/failures.dart';
import 'package:quizapp/features/auth/domain/entity/user_entity.dart';
import 'package:quizapp/core/usecases.dart';
import 'package:quizapp/features/auth/domain/repositories/user_repositories.dart';

class RefreshTokenUsecase extends UseCase<UserEntity, NoParams> {
  final UserRepository repository;

  RefreshTokenUsecase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) {
    return repository.refreshToken();
  }
}
