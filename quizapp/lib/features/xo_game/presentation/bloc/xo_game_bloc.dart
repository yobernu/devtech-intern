import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/game_state.dart';
import '../../domain/entities/player.dart';

import '../../domain/repositories/xo_repository.dart';

part 'xo_game_event.dart';
part 'xo_game_state.dart';

class XoGameBloc extends Bloc<XoGameEvent, XoGameState> {
  final XoRepository repository;

  XoGameBloc({required this.repository}) : super(XoGameInitial()) {
    on<StartGame>(_onStartGame);
    on<CallPlayer>(_onCallPlayer);
    on<ResetGame>(_onResetGame);
  }

  void _onStartGame(StartGame event, Emitter<XoGameState> emit) {
    final playerNames = event.playerNames;
    if (playerNames.length % 2 != 0) {
      // Should be handled in UI, but safety check
      return;
    }

    // 1. Create Players with IDs
    final players = playerNames
        .map(
          (name) => Player(
            id: const Uuid().v4(),
            originalName: name,
            assignedName: '', // To be assigned
            symbol: '', // To be assigned
          ),
        )
        .toList();

    // 2. Shuffle for Assigned Names (Derangement)
    final shuffledNames = List<String>.from(playerNames)..shuffle();
    // Simple derangement attempt
    bool isDerangement = false;
    while (!isDerangement) {
      isDerangement = true;
      for (int i = 0; i < players.length; i++) {
        if (players[i].originalName == shuffledNames[i]) {
          isDerangement = false;
          shuffledNames.shuffle();
          break;
        }
      }
    }

    // 3. Assign Names and Symbols
    // Half X, Half O
    int half = players.length ~/ 2;
    for (int i = 0; i < players.length; i++) {
      players[i] = players[i].copyWith(
        assignedName: shuffledNames[i],
        symbol: i < half
            ? 'X'
            : 'O', // First half X, second half O (randomized by shuffle above? No, need to shuffle players list first if we want random symbols)
      );
    }
    // Shuffle players list to randomize who gets X/O relative to input order
    players.shuffle();

    // 4. Setup Chairs (N+1)
    // Kings Chairs: 0, 1, 2
    // Initial State: Chair 0 (X), Chair 1 (O), Chair 2 (Empty)
    // Remaining players fill remaining chairs
    final kingsChairIndices = [0, 1, 2];
    final totalChairs = players.length + 1;
    List<Player?> chairs = List.filled(totalChairs, null);

    // Find one X and one O for Kings Chairs
    Player? xPlayer;
    Player? oPlayer;
    List<Player> remainingPlayers = [];

    for (var p in players) {
      if (xPlayer == null && p.symbol == 'X') {
        xPlayer = p;
      } else if (oPlayer == null && p.symbol == 'O') {
        oPlayer = p;
      } else {
        remainingPlayers.add(p);
      }
    }

    chairs[0] = xPlayer;
    chairs[1] = oPlayer;
    chairs[2] = null; // Empty

    // Fill rest
    for (int i = 0; i < remainingPlayers.length; i++) {
      chairs[3 + i] = remainingPlayers[i];
    }

    // 5. Determine Starting Player
    // "game starts with the person after the kings chairs" -> Chair 3
    // If Chair 3 is empty (unlikely with logic above), move to next.
    int startIndex = 3;
    // Find the player at startIndex in the allPlayers list to set currentPlayerIndex
    // currentPlayerIndex refers to index in `allPlayers` list, NOT chair index.
    Player startPlayer = chairs[startIndex]!;
    int startPlayerIndex = players.indexOf(startPlayer);

    final gameState = GameState(
      chairs: chairs,
      kingsChairIndices: kingsChairIndices,
      allPlayers: players,
      currentPlayerIndex: startPlayerIndex,
      roundNumber: 1,
      calledPlayers: {},
    );

    emit(XoGameInProgress(gameState));
  }

  void _onCallPlayer(CallPlayer event, Emitter<XoGameState> emit) {
    final currentState = state;
    if (currentState is! XoGameInProgress) return;

    final game = currentState.gameState;
    final calledPlayerId = event.calledPlayerId;

    // Validation: Can't call self? (Not specified, but logical)
    // "every one picks a name different from his one... calls one person"
    if (game.currentPlayer.id == calledPlayerId) return;

    // Validation: King's Chair Lock
    // "called kings for king's posistion can be recalled only after three rounds"
    // Check if player is currently in a King's Chair
    int calledPlayerChairIndex = -1;
    for (int i = 0; i < game.chairs.length; i++) {
      if (game.chairs[i]?.id == calledPlayerId) {
        calledPlayerChairIndex = i;
        break;
      }
    }
    if (calledPlayerChairIndex == -1) return; // Should not happen

    if (game.kingsChairIndices.contains(calledPlayerChairIndex)) {
      // Player is in a King's Chair. Check if they are locked.
      if (game.kingsArrivalRound.containsKey(calledPlayerId)) {
        final arrivalRound = game.kingsArrivalRound[calledPlayerId]!;
        if (game.roundNumber - arrivalRound < 3) {
          // Locked
          return;
        }
      }
      // If not in kingsArrivalRound, they are an Original King and can be moved freely.
    }

    // Move to Empty Spot
    int emptyIndex = game.emptyChairIndex;
    List<Player?> newChairs = List.from(game.chairs);
    newChairs[emptyIndex] = newChairs[calledPlayerChairIndex];
    newChairs[calledPlayerChairIndex] = null; // Old spot becomes empty

    // Check Win Condition
    // Check if kingsChairIndices are all same symbol
    String? firstSymbol;
    bool isWin = true;
    for (int idx in game.kingsChairIndices) {
      final p = newChairs[idx];
      if (p == null) {
        isWin = false;
        break;
      }
      if (firstSymbol == null) {
        firstSymbol = p.symbol;
      } else if (firstSymbol != p.symbol) {
        isWin = false;
        break;
      }
    }

    if (isWin) {
      // Save score for winner? Or all team members?
      // "Main goal of game is to make all three kings chairs only Xs or Os."
      // Let's increment score for all players with the winning symbol.
      final winningSymbol = firstSymbol!;
      for (var p in game.allPlayers) {
        if (p.symbol == winningSymbol) {
          // Fire and forget save
          _updateScore(p.id);
        }
      }
      emit(XoGameWon(game.copyWith(chairs: newChairs), winningSymbol));
      return;
    }

    // Update Turn
    // "next turn will start from the next of moved person"
    // Moved person was at `calledPlayerChairIndex`.
    // Next chair index:
    int nextTurnChairIndex = (calledPlayerChairIndex + 1) % newChairs.length;

    // If next chair is empty (it shouldn't be, because we just emptied calledPlayerChairIndex, so next one is likely occupied unless adjacent was empty? No, only 1 empty chair).
    // If next chair is empty (e.g. calledPlayerChairIndex was N, and N+1 is 0 which is empty? No empty is unique).
    // Wait, `calledPlayerChairIndex` is now empty.
    // "next of moved person" -> The person sitting next to where the moved person WAS?
    // Yes.

    Player? nextPlayer = newChairs[nextTurnChairIndex];
    // If next spot is empty (edge case?), go to next next.
    while (nextPlayer == null) {
      nextTurnChairIndex = (nextTurnChairIndex + 1) % newChairs.length;
      nextPlayer = newChairs[nextTurnChairIndex];
    }

    int nextPlayerIndex = game.allPlayers.indexOf(nextPlayer);

    // Update Round/History
    Map<String, int> newCalledPlayers = Map.from(game.calledPlayers);
    newCalledPlayers[calledPlayerId] = game.roundNumber;

    // Increment round? Or is round global?
    // "until third round". Usually round implies everyone has gone once?
    // Or maybe just a counter. Let's increment round if we cycle back?
    // For now, let's just keep roundNumber as is, maybe increment if `calledPlayers` size reaches N?
    int newRoundNumber = game.roundNumber;
    if (newCalledPlayers.length % game.allPlayers.length == 0) {
      newRoundNumber++;
    }

    // Update King Arrival Tracking
    Map<String, int> newKingsArrivalRound = Map.from(game.kingsArrivalRound);
    if (game.kingsChairIndices.contains(emptyIndex)) {
      // Moved INTO a King's Chair
      newKingsArrivalRound[calledPlayerId] = newRoundNumber;
    } else {
      // Moved OUT of a King's Chair (or from civilian to civilian)
      // If they were in a King's Chair, they are no longer there, so remove entry.
      newKingsArrivalRound.remove(calledPlayerId);
    }

    emit(
      XoGameInProgress(
        game.copyWith(
          chairs: newChairs,
          currentPlayerIndex: nextPlayerIndex,
          calledPlayers: newCalledPlayers,
          kingsArrivalRound: newKingsArrivalRound,
          roundNumber: newRoundNumber,
        ),
      ),
    );
  }

  void _onResetGame(ResetGame event, Emitter<XoGameState> emit) {
    emit(XoGameInitial());
  }

  Future<void> _updateScore(String playerId) async {
    try {
      final currentScore = await repository.getScore(playerId);
      await repository.saveScore(playerId, currentScore + 1);
    } catch (e) {
      // Ignore errors for now
    }
  }
}
