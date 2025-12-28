part of 'xo_game_bloc.dart';

abstract class XoGameState extends Equatable {
  const XoGameState();

  @override
  List<Object?> get props => [];
}

class XoGameInitial extends XoGameState {}

class XoGameInProgress extends XoGameState {
  final GameState gameState;

  const XoGameInProgress(this.gameState);

  @override
  List<Object?> get props => [gameState];
}

class XoGameWon extends XoGameState {
  final GameState gameState;
  final String winnerSymbol; // 'X' or 'O'

  const XoGameWon(this.gameState, this.winnerSymbol);

  @override
  List<Object?> get props => [gameState, winnerSymbol];
}
