import 'package:equatable/equatable.dart';
import 'package:quizapp/core/errors/failures.dart';

abstract class UserScoreState extends Equatable {
  const UserScoreState();

  @override
  List<Object?> get props => [];
}

class UserScoreInitial extends UserScoreState {
  const UserScoreInitial();
}

class UserScoreLoading extends UserScoreState {
  const UserScoreLoading();
}

class UserScoreLoaded extends UserScoreState {
  final int score;

  const UserScoreLoaded(this.score);

  @override
  List<Object?> get props => [score];
}

class UserScoreError extends UserScoreState {
  final Failure failure;

  const UserScoreError(this.failure);

  @override
  List<Object?> get props => [failure];
}
