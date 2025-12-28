import 'package:equatable/equatable.dart';
import 'player.dart';

class GameState extends Equatable {
  final List<Player?> chairs;
  final List<int> kingsChairIndices;
  final List<Player> allPlayers;
  final int currentPlayerIndex;
  final int roundNumber;
  final Map<String, int> calledPlayers;
  final Map<String, int> kingsArrivalRound;

  const GameState({
    required this.chairs,
    required this.kingsChairIndices,
    required this.allPlayers,
    required this.currentPlayerIndex,
    required this.roundNumber,
    required this.calledPlayers,
    this.kingsArrivalRound = const {},
  });

  @override
  List<Object?> get props => [
    chairs,
    kingsChairIndices,
    allPlayers,
    currentPlayerIndex,
    roundNumber,
    calledPlayers,
    kingsArrivalRound,
  ];

  GameState copyWith({
    List<Player?>? chairs,
    List<int>? kingsChairIndices,
    List<Player>? allPlayers,
    int? currentPlayerIndex,
    int? roundNumber,
    Map<String, int>? calledPlayers,
    Map<String, int>? kingsArrivalRound,
  }) {
    return GameState(
      chairs: chairs ?? this.chairs,
      kingsChairIndices: kingsChairIndices ?? this.kingsChairIndices,
      allPlayers: allPlayers ?? this.allPlayers,
      currentPlayerIndex: currentPlayerIndex ?? this.currentPlayerIndex,
      roundNumber: roundNumber ?? this.roundNumber,
      calledPlayers: calledPlayers ?? this.calledPlayers,
      kingsArrivalRound: kingsArrivalRound ?? this.kingsArrivalRound,
    );
  }

  Player get currentPlayer => allPlayers[currentPlayerIndex];

  int get emptyChairIndex => chairs.indexOf(null);
}
