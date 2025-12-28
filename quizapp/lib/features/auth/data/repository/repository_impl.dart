import 'package:dartz/dartz.dart';
import 'package:quizapp/core/errors/exceptions.dart';
import 'package:quizapp/core/errors/failures.dart';
import 'package:quizapp/core/network_info.dart';
import 'package:quizapp/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:quizapp/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:quizapp/features/auth/domain/entity/user_entity.dart';
import 'package:quizapp/features/auth/domain/repositories/user_repositories.dart';

class RepositoryImpl implements UserRepository {
  final RemoteAuthDataSource remoteDataSource;
  final LocalAuthDataSource localDataSource;
  final NetworkInfo networkInfo;

  RepositoryImpl(
    this.remoteDataSource,
    this.localDataSource,
    this.networkInfo, {
    required Object client,
  });

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      try {
        final user = await remoteDataSource.getCurrentUser();
        // Cache user data after successful fetch
        await localDataSource.cacheUser(user);
        return Right(user);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      // Offline: Try to return cached user
      try {
        final cachedUser = await localDataSource.getCachedUser();
        return Right(cachedUser);
      } on CacheException {
        return Left(CacheFailure('No cached user data available'));
      }
    }
  }

  // NOTE: The original isAuthenticated() method has been removed as it did not
  // align with the expected domain model (UserEntity) or the BLoC's status check flow.

  @override
  Future<Either<Failure, Unit>> resetPassword({required String email}) {
    // TODO: implement resetPassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserEntity>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      final user = await remoteDataSource.signUp(
        name: name,
        email: email,
        password: password,
      );
      // Cache user data after successful signup
      await localDataSource.cacheUser(user);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  }) async {
    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      final user = await remoteDataSource.signIn(
        email: email,
        password: password,
      );
      // Cache user data after successful login
      await localDataSource.cacheUser(user);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      final user = await remoteDataSource.signInWithGoogle();
      await localDataSource.cacheUser(user);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> signInWithPhone({
    required String phoneNumber,
  }) async {
    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      await remoteDataSource.signInWithPhone(phoneNumber: phoneNumber);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> verifyPhoneOtp({
    required String phone,
    required String token,
  }) async {
    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      final user = await remoteDataSource.verifyPhoneOtp(
        phone: phone,
        token: token,
      );
      await localDataSource.cacheUser(user);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      // remoteDataSource.signOut() is called, but the repository must return Unit
      await remoteDataSource.signOut();
      // Clear cached user data on logout
      await localDataSource.clearCache();
      return const Right(unit); // FIXED: Correctly returns Unit on success
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // New method required by the AuthBloc's session management flow
  @override
  Future<Either<Failure, UserEntity>> refreshToken() async {
    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      // Assuming a refreshToken method exists on the RemoteDataSource
      // which returns the updated UserEntity on success.
      final user = await remoteDataSource.refreshToken();
      // Update cached user data after token refresh
      await localDataSource.cacheUser(user);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // @override
  // Future<Either<Failure, Unit>> updatePassword({required String password}) async {
  //   final isConnected = await networkInfo.isConnected;

  //   if (!isConnected) {
  //     return Left(NetworkFailure('No internet connection'));
  //   }

  //   try {
  //     // Assuming remoteDataSource.updatePassword returns void/Unit
  //     await remoteDataSource.updatePassword(password: password);
  //     return const Right(unit);
  //   } on ServerException catch (e) {
  //     return Left(ServerFailure(e.message));
  //   } catch (e) {
  //     return Left(ServerFailure(e.toString()));
  //   }
  // }

  @override
  Future<Either<Failure, Unit>> updateProfile({
    required String name,
    required String email,
    required String password,
  }) async {
    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      // Assuming remoteDataSource.updateProfile returns void/Unit
      await remoteDataSource.updateProfile(
        name: name,
        email: email,
        password: password,
      );
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateProfilePicture({
    required String imageUrl,
  }) async {
    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      // Assuming remoteDataSource.updateProfilePicture returns void/Unit
      await remoteDataSource.updateProfilePicture(imageUrl: imageUrl);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isAuthenticated() async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      try {
        final isAuth = await remoteDataSource.isAuthenticated();
        return Right(isAuth);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      // Offline: Check if we have cached user data
      try {
        final hasCache = await localDataSource.hasCache();
        return Right(hasCache);
      } catch (e) {
        return Right(false);
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> updateUserScore(int score) async {
    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      await remoteDataSource.updateUserScore(score);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
