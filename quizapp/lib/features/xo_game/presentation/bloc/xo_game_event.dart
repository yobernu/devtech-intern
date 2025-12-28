part of 'xo_game_bloc.dart';

abstract class XoGameEvent extends Equatable {
  const XoGameEvent();

  @override
  List<Object> get props => [];
}

class StartGame extends XoGameEvent {
  final List<String> playerNames;

  const StartGame(this.playerNames);

  @override
  List<Object> get props => [playerNames];
}

class CallPlayer extends XoGameEvent {
  final String calledPlayerId;

  const CallPlayer(this.calledPlayerId);

  @override
  List<Object> get props => [calledPlayerId];
}

class ResetGame extends XoGameEvent {}
