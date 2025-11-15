import 'package:dartz/dartz.dart';
import 'package:quizapp/core/errors/exceptions.dart';
import 'package:quizapp/core/errors/failures.dart';
import 'package:quizapp/core/network_info.dart';
import 'package:quizapp/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:quizapp/features/auth/domain/entity/user_entity.dart';
import 'package:quizapp/features/auth/domain/repositories/user_repositories.dart';

class RepositoryImpl implements UserRepository {
  final RemoteAuthDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  RepositoryImpl(
    this.remoteDataSource,
    this.networkInfo, {
    required Object client,
  });

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }
    try {
      final user = await remoteDataSource.getCurrentUser();
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
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
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() {
    // TODO: implement signInWithGoogle
    throw UnimplementedError();
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
      return const Right(unit); // FIXED: Correctly returns Unit on success
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // New method required by the AuthBloc's session management flow
  Future<Either<Failure, UserEntity>> refreshToken() async {
    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      // Assuming a refreshToken method exists on the RemoteDataSource
      // which returns the updated UserEntity on success.
      final user = await remoteDataSource.refreshToken();
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

    if (!isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }
    try {
      final user = await remoteDataSource.isAuthenticated();
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
