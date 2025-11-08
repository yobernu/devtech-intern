import 'package:dartz/dartz.dart';
import 'package:quizapp/core/usecases.dart';
import '../../../../core/errors/failures.dart';
import '../entity/user_entity.dart';
import '../repositories/user_repositories.dart';

class SignupUParams extends Params {
  final String name;
  final String email;
  final String password;

  const SignupUParams({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, password];
}

class SignUpUseCase implements UseCase<UserEntity, SignupUParams> {
  final UserRepository repository;

  SignUpUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(SignupUParams params) async {
    return await repository.signUp(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}
