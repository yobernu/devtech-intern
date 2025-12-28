import 'package:equatable/equatable.dart';

abstract class LeaderboardEvent extends Equatable {
  const LeaderboardEvent();

  @override
  List<Object> get props => [];
}

class FetchLeaderboardEvent extends LeaderboardEvent {
  final String period;

  const FetchLeaderboardEvent({this.period = 'all_time'});

  @override
  List<Object> get props => [period];
}
