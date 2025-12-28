import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/core/constants/appcolors.dart';
import 'package:quizapp/features/presentation/helpers/meshBackground.dart';
import 'package:quizapp/features/xo_game/domain/entities/game_state.dart';
import '../bloc/xo_game_bloc.dart';
import '../../domain/entities/player.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'X/O Kings',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<XoGameBloc>().add(ResetGame());
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: MeshGradientBackground(
        child: BlocConsumer<XoGameBloc, XoGameState>(
          listener: (context, state) {
            if (state is XoGameWon) {
              _showWinDialog(context, state);
            }
          },
          builder: (context, state) {
            if (state is! XoGameInProgress && state is! XoGameWon) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            final gameState = (state is XoGameWon)
                ? state.gameState
                : (state as XoGameInProgress).gameState;
            final currentPlayer = gameState.currentPlayer;

            return SafeArea(
              child: Column(
                children: [
                  // Status Bar
                  _buildStatusBar(gameState.roundNumber, currentPlayer),

                  // Game Board
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final center = Offset(
                          constraints.maxWidth / 2,
                          constraints.maxHeight / 2,
                        );
                        final radius =
                            min(constraints.maxWidth, constraints.maxHeight) *
                            0.35;

                        return Stack(
                          children: [
                            // Center Info
                            Center(child: _buildCenterInfo()),

                            // Chairs
                            ...List.generate(gameState.chairs.length, (index) {
                              final player = gameState.chairs[index];
                              final isKing = gameState.kingsChairIndices
                                  .contains(index);

                              // Check Lock Status
                              bool isLocked = false;
                              if (isKing && player != null) {
                                if (gameState.kingsArrivalRound.containsKey(
                                  player.id,
                                )) {
                                  final arrivalRound =
                                      gameState.kingsArrivalRound[player.id]!;
                                  if (gameState.roundNumber - arrivalRound <
                                      3) {
                                    isLocked = true;
                                  }
                                }
                              }

                              final angle =
                                  (2 * pi * index) / gameState.chairs.length -
                                  pi / 2;

                              return Positioned(
                                left: center.dx + radius * cos(angle) - 35,
                                top: center.dy + radius * sin(angle) - 35,
                                child: _ChairWidget(
                                  player: player,
                                  isKing: isKing,
                                  isLocked: isLocked,
                                  index: index,
                                ),
                              );
                            }),
                          ],
                        );
                      },
                    ),
                  ),

                  // Controls
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: _buildCallButton(context, gameState),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatusBar(int round, Player currentPlayer) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ROUND',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 10,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    '$round',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'CURRENT TURN',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 10,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        currentPlayer.assignedName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: currentPlayer.symbol == 'X'
                              ? AppColors.smallButtonBlue
                              : AppColors.smallButtonRed,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          currentPlayer.symbol,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenterInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.1),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.arrow_circle_down_outlined,
            color: Colors.amber,
            size: 32,
          ),
          const SizedBox(height: 4),
          const Text(
            'KINGS',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _KingsIndicator(symbol: 'X'),
              const SizedBox(width: 8),
              _KingsIndicator(symbol: 'O'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCallButton(BuildContext context, GameState gameState) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [AppColors.accentPink, AppColors.secondaryPurple],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentPink.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () {
            _showCallPlayerDialog(context, gameState);
          },
          child: const Center(
            child: Text(
              'CALL PLAYER',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showWinDialog(BuildContext context, XoGameWon state) {
    final bloc = context.read<XoGameBloc>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.emoji_events, size: 60, color: Colors.amber),
              const SizedBox(height: 16),
              Text(
                'TEAM ${state.winnerSymbol} WINS!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Congratulations to the winners!',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    bloc.add(ResetGame());
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Go back to setup
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'NEW GAME',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCallPlayerDialog(BuildContext context, GameState gameState) {
    final allPlayers = gameState.allPlayers;
    final currentId = gameState.currentPlayer.id;
    final chairs = gameState.chairs;
    final kingsChairIndices = gameState.kingsChairIndices;
    final kingsArrivalRound = gameState.kingsArrivalRound;
    final roundNumber = gameState.roundNumber;
    final bloc = context.read<XoGameBloc>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return BlocProvider.value(
          value: bloc,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'Select Player to Call',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: allPlayers.length,
                    itemBuilder: (context, index) {
                      final player = allPlayers[index];
                      if (player.id == currentId)
                        return const SizedBox.shrink();

                      bool isLocked = false;
                      // Find player's chair
                      int chairIndex = -1;
                      for (int i = 0; i < chairs.length; i++) {
                        if (chairs[i]?.id == player.id) {
                          chairIndex = i;
                          break;
                        }
                      }

                      if (chairIndex != -1 &&
                          kingsChairIndices.contains(chairIndex)) {
                        if (kingsArrivalRound.containsKey(player.id)) {
                          final arrivalRound = kingsArrivalRound[player.id]!;
                          if (roundNumber - arrivalRound < 3) {
                            isLocked = true;
                          }
                        }
                      }

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: player.symbol == 'X'
                                ? AppColors.smallButtonBlue.withOpacity(0.1)
                                : AppColors.smallButtonRed.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              player.symbol,
                              style: TextStyle(
                                color: player.symbol == 'X'
                                    ? AppColors.smallButtonBlue
                                    : AppColors.smallButtonRed,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          player.assignedName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          'Original: ${player.originalName}',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        trailing: isLocked
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.lock,
                                      size: 12,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Locked',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.grey,
                              ),
                        onTap: isLocked
                            ? null
                            : () {
                                bloc.add(CallPlayer(player.id));
                                Navigator.pop(context);
                              },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ChairWidget extends StatelessWidget {
  final Player? player;
  final bool isKing;
  final bool isLocked;
  final int index;

  const _ChairWidget({
    required this.player,
    required this.isKing,
    this.isLocked = false,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: player == null
                ? Colors.white.withOpacity(0.1)
                : Colors.white,
            border: isKing
                ? Border.all(color: Colors.amber, width: 3)
                : Border.all(color: Colors.white.withOpacity(0.5), width: 2),
            boxShadow: [
              if (isKing)
                BoxShadow(
                  color: Colors.amber.withOpacity(0.5),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              if (player != null)
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
            ],
          ),
          child: Stack(
            children: [
              Center(
                child: player == null
                    ? Icon(
                        Icons.event_seat_outlined,
                        color: Colors.white.withOpacity(0.5),
                        size: 30,
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            player!.symbol,
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 24,
                              color: player!.symbol == 'X'
                                  ? AppColors.smallButtonBlue
                                  : AppColors.smallButtonRed,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            player!.assignedName,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkText,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
              ),
              if (isLocked)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Icon(Icons.lock, size: 10, color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
        if (isKing)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'KING',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _KingsIndicator extends StatelessWidget {
  final String symbol;
  const _KingsIndicator({required this.symbol});

  @override
  Widget build(BuildContext context) {
    final color = symbol == 'X'
        ? AppColors.smallButtonBlue
        : AppColors.smallButtonRed;
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      child: Center(
        child: Text(
          symbol,
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
      ),
    );
  }
}
