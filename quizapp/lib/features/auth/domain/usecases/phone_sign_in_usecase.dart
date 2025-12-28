import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quizapp/core/errors/failures.dart';
import 'package:quizapp/core/usecases.dart';
import 'package:quizapp/features/auth/domain/repositories/user_repositories.dart';

class PhoneSignInUseCase implements UseCase<Unit, PhoneSignInParams> {
  final UserRepository repository;

  PhoneSignInUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(PhoneSignInParams params) async {
    return await repository.signInWithPhone(phoneNumber: params.phoneNumber);
  }
}

class PhoneSignInParams extends Equatable {
  final String phoneNumber;

  const PhoneSignInParams({required this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];
}
