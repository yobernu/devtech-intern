// import 'package:dartz/dartz.dart';
// import 'package:quizapp/core/usecases.dart';
// import '../../../../core/errors/failures.dart';
// import '../entity/user_entity.dart';
// import '../repositories/user_repositories.dart';

// class VerifyEmailWithTokenParams extends Params {
//   final String email;
//   final String? token;

//   const VerifyEmailWithTokenParams({required this.email, required this.token});

//   @override
//   List<Object?> get props => [email, token];
// }

// class VerifyEmailWithTokenUseCase
//     implements UseCase<UserEntity, VerifyEmailWithTokenParams> {
//   final UserRepository repository;
//   VerifyEmailWithTokenUseCase(this.repository);

//   @override
//   Future<Either<Failure, UserEntity>> call(
//     VerifyEmailWithTokenParams params,
//   ) async {
//     return await repository.verifyEmailWithToken(
//       email: params.email,
//       token: params.token,
//     );
//   }
// }
