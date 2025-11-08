import 'package:dartz/dartz.dart';
import 'package:quizapp/core/usecases.dart';
import 'package:quizapp/core/errors/failures.dart';
import 'package:quizapp/features/auth/domain/entity/user_entity.dart';
import 'package:quizapp/features/auth/domain/repositories/user_repositories.dart';

class GetCurrentUserUseCase implements UseCase<UserEntity, NoParams> {
  final UserRepository repository;

  GetCurrentUserUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}
