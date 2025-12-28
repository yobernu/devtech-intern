import 'package:dartz/dartz.dart';
import 'package:quizapp/core/errors/failures.dart';
import 'package:quizapp/core/usecases.dart';
import 'package:quizapp/features/domain/entities/leaderboard_entity.dart';
import 'package:quizapp/features/domain/repositories/leaderboard_repository.dart';

class GetLeaderboardParams extends Params {
  final String period;
  final int limit;

  const GetLeaderboardParams({this.period = 'all_time', this.limit = 10});

  @override
  List<Object?> get props => [period, limit];
}

class GetLeaderboardUseCase
    extends UseCase<List<LeaderboardEntry>, GetLeaderboardParams> {
  final LeaderboardRepository repository;

  GetLeaderboardUseCase(this.repository);

  @override
  Future<Either<Failure, List<LeaderboardEntry>>> call(
    GetLeaderboardParams params,
  ) async {
    return await repository.getLeaderboard(
      period: params.period,
      limit: params.limit,
    );
  }
}
