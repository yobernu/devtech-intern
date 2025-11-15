import 'package:dartz/dartz.dart';
import 'package:quizapp/core/errors/failures.dart';
import 'package:quizapp/core/usecases.dart';
import 'package:quizapp/features/auth/domain/entity/user_entity.dart';
import 'package:quizapp/features/auth/domain/repositories/user_repositories.dart';

class SignOutParams extends Params {
  const SignOutParams();

  @override
  List<Object?> get props => [];
}

class SignOutUseCase extends UseCase<Unit, NoParams> {
  final UserRepository repository;

  SignOutUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) {
    return repository.signOut();
  }
}
