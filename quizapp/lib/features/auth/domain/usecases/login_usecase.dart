import 'package:dartz/dartz.dart';
import 'package:quizapp/core/errors/failures.dart';
import 'package:quizapp/core/usecases.dart';
import 'package:quizapp/features/auth/domain/entity/user_entity.dart';
import 'package:quizapp/features/auth/domain/repositories/user_repositories.dart';

class LoginParams extends Params {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class LoginUseCase extends UseCase<UserEntity, LoginParams> {
  final UserRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) {
    return repository.signIn(email: params.email, password: params.password);
  }
}
