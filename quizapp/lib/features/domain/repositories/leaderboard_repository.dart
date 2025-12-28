import 'package:dartz/dartz.dart';
import 'package:quizapp/core/errors/failures.dart';
import 'package:quizapp/features/domain/entities/leaderboard_entity.dart';

abstract class LeaderboardRepository {
  Future<Either<Failure, List<LeaderboardEntry>>> getLeaderboard({
    String period = 'all_time', // 'weekly', 'monthly', 'all_time'
    int limit = 10,
  });

  Future<Either<Failure, LeaderboardEntry>> getUserRank(String userId);
}
