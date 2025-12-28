import 'package:equatable/equatable.dart';
import 'package:quizapp/features/domain/entities/leaderboard_entity.dart';

abstract class LeaderboardState extends Equatable {
  const LeaderboardState();

  @override
  List<Object> get props => [];
}

class LeaderboardInitial extends LeaderboardState {}

class LeaderboardLoading extends LeaderboardState {}

class LeaderboardLoaded extends LeaderboardState {
  final List<LeaderboardEntry> leaderboard;
  final LeaderboardEntry? userRank;

  const LeaderboardLoaded({required this.leaderboard, this.userRank});

  @override
  List<Object> get props => [leaderboard, if (userRank != null) userRank!];
}

class LeaderboardError extends LeaderboardState {
  final String message;

  const LeaderboardError(this.message);

  @override
  List<Object> get props => [message];
}
