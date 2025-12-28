import 'package:dartz/dartz.dart';
import 'package:quizapp/core/errors/failures.dart';

import '../entity/user_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, UserEntity>> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> signInWithGoogle();

  Future<Either<Failure, Unit>> signInWithPhone({required String phoneNumber});

  Future<Either<Failure, UserEntity>> verifyPhoneOtp({
    required String phone,
    required String token,
  });

  Future<Either<Failure, Unit>> signOut();

  Future<Either<Failure, UserEntity>> getCurrentUser();

  Future<Either<Failure, Unit>> updateProfile({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, Unit>> updateProfilePicture({
    required String imageUrl,
  });

  // Future<Either<Failure, Unit>> updatePassword({required String password});

  Future<Either<Failure, Unit>> resetPassword({required String email});
  Future<Either<Failure, bool>> isAuthenticated();
  Future<Either<Failure, UserEntity>> refreshToken();
  Future<Either<Failure, Unit>> updateUserScore(int score);
}
