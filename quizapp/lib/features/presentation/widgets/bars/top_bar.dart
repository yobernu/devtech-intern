import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:quizapp/core/constants/appcolors.dart";
import "package:quizapp/features/presentation/provider/auth/auth_bloc.dart";
import "package:quizapp/features/presentation/provider/auth/auth_state.dart";
import "package:quizapp/features/presentation/provider/user_score/user_score_bloc.dart";
import "package:quizapp/features/presentation/provider/user_score/user_score_event.dart";
import "package:quizapp/features/presentation/provider/user_score/user_score_state.dart";

class TopBar extends StatefulWidget {
  const TopBar({super.key});

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  @override
  void initState() {
    super.initState();
    context.read<UserScoreBloc>().add(const GetUserScoreEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        children: [
          // Profile Info
          const CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(
              'https://images.unsplash.com/photo-1762893021980-b6accb9b94d9?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
            ),
            backgroundColor: AppColors.surfaceWhite,
          ),
          const SizedBox(width: 12),
          BlocBuilder<AuthBloc, UserState>(
            builder: (context, authState) {
              String username = 'Guest User';
              String rank = 'Beginner';

              // Check all possible authenticated states
              if (authState is UserAuthenticatedState) {
                username = authState.user.username;
                rank = authState.user.rank;
              } else if (authState is UserLogInSuccessState) {
                username = authState.user.username;
                rank = authState.user.rank;
              } else if (authState is UserSignUpSuccessState) {
                username = authState.user.username;
                rank = authState.user.rank;
              } else if (authState is UserSuccessState) {
                username = authState.user.username;
                rank = authState.user.rank;
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: const TextStyle(
                      color: AppColors.surfaceWhite,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    rank,
                    style: const TextStyle(
                      color: AppColors.surfaceWhite,
                      fontSize: 12,
                    ),
                  ),
                ],
              );
            },
          ),
          const Spacer(),
          // Score Card with BLoC
          BlocBuilder<UserScoreBloc, UserScoreState>(
            builder: (context, state) {
              String scoreText = '0';

              if (state is UserScoreLoaded) {
                scoreText = state.score.toString();
              } else if (state is UserScoreLoading) {
                scoreText = '...';
              }

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.flash_on,
                      color: AppColors.accentPink,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      scoreText,
                      style: const TextStyle(
                        color: AppColors.surfaceWhite,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

Widget buildTopBar(BuildContext context) {
  return const TopBar();
}
