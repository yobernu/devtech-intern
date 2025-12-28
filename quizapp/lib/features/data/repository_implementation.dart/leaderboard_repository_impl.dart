import 'package:dartz/dartz.dart';
import 'package:quizapp/core/errors/failures.dart';
import 'package:quizapp/core/network_info.dart';
import 'package:quizapp/features/data/datasources/remote_datasource/leaderboard_remote_datasource.dart';
import 'package:quizapp/features/domain/entities/leaderboard_entity.dart';
import 'package:quizapp/features/domain/repositories/leaderboard_repository.dart';

class LeaderboardRepositoryImpl implements LeaderboardRepository {
  final LeaderboardRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  LeaderboardRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<LeaderboardEntry>>> getLeaderboard({
    String period = 'all_time',
    int limit = 10,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final leaderboard = await remoteDataSource.getLeaderboard(
          period,
          limit,
        );
        return Right(leaderboard);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, LeaderboardEntry>> getUserRank(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final userRank = await remoteDataSource.getUserRank(userId);
        return Right(userRank);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }
}
