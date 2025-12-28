import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quizapp/core/errors/failures.dart';
import 'package:quizapp/core/usecases.dart';
import 'package:quizapp/features/auth/domain/entity/user_entity.dart';
import 'package:quizapp/features/auth/domain/repositories/user_repositories.dart';

class VerifyOtpUseCase implements UseCase<UserEntity, VerifyOtpParams> {
  final UserRepository repository;

  VerifyOtpUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(VerifyOtpParams params) async {
    return await repository.verifyPhoneOtp(
      phone: params.phone,
      token: params.token,
    );
  }
}

class VerifyOtpParams extends Equatable {
  final String phone;
  final String token;

  const VerifyOtpParams({required this.phone, required this.token});

  @override
  List<Object> get props => [phone, token];
}
