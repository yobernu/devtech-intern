import 'package:equatable/equatable.dart';

abstract class UserScoreEvent extends Equatable {
  const UserScoreEvent();

  @override
  List<Object?> get props => [];
}

class GetUserScoreEvent extends UserScoreEvent {
  const GetUserScoreEvent();
}
