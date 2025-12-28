import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/core/constants/appcolors.dart';
import 'package:quizapp/features/domain/entities/leaderboard_entity.dart';
import 'package:quizapp/features/presentation/di_container.dart' as di;
import 'package:quizapp/features/presentation/helpers/meshBackground.dart';
import 'package:quizapp/features/presentation/provider/leaderboard/leaderboard_bloc.dart';
import 'package:quizapp/features/presentation/provider/leaderboard/leaderboard_event.dart';
import 'package:quizapp/features/presentation/provider/leaderboard/leaderboard_state.dart';

class LeaderBoardScreen extends StatefulWidget {
  const LeaderBoardScreen({super.key});

  @override
  State<LeaderBoardScreen> createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          di.sl<LeaderboardBloc>()..add(const FetchLeaderboardEvent()),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        body: MeshGradientBackground(
          child: SafeArea(
            child: BlocBuilder<LeaderboardBloc, LeaderboardState>(
              builder: (context, state) {
                if (state is LeaderboardLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is LeaderboardError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else if (state is LeaderboardLoaded) {
                  final leaderboard = state.leaderboard;
                  if (leaderboard.isEmpty) {
                    return const Center(
                      child: Text('No leaderboard data available.'),
                    );
                  }

                  // Split data for podium (top 3) and list (rest)
                  final top3 = leaderboard.take(3).toList();
                  final rest = leaderboard.skip(3).toList();

                  // Ensure we have enough data for podium, fill with placeholders if needed
                  // This is a bit simplified, ideally we handle < 3 users gracefully
                  final first = top3.isNotEmpty ? top3[0] : null;
                  final second = top3.length > 1 ? top3[1] : null;
                  final third = top3.length > 2 ? top3[2] : null;

                  return CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 24),
                          child: PodiumWidget(
                            first: first,
                            second: second,
                            third: third,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          decoration: BoxDecoration(
                            color: AppColors.lightSurface,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              ...rest.map((entry) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 4.0,
                                  ),
                                  child: LeaderboardListItem(
                                    rank: entry.rank,
                                    title: entry.username,
                                    points: entry.score,
                                    // Highlight if it's the current user (this logic needs current user ID)
                                    // For now, we don't have current user ID easily accessible here without AuthBloc
                                    // We can improve this later.
                                    isUser: false,
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 32)),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}

class PodiumWidget extends StatelessWidget {
  final LeaderboardEntry? first;
  final LeaderboardEntry? second;
  final LeaderboardEntry? third;

  const PodiumWidget({super.key, this.first, this.second, this.third});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (second != null)
          _buildPodiumPlace(
            context,
            name: second!.username,
            color: AppColors.smallButtonBlue,
            height: 150,
            rank: 2,
            avatarUrl: second!.profileImageUrl.isNotEmpty
                ? second!.profileImageUrl
                : 'https://ui-avatars.com/api/?name=${second!.username}&background=random',
          ),
        const SizedBox(width: 12),
        if (first != null)
          _buildPodiumPlace(
            context,
            name: first!.username,
            color: AppColors.primaryPurple,
            height: 180,
            rank: 1,
            avatarUrl: first!.profileImageUrl.isNotEmpty
                ? first!.profileImageUrl
                : 'https://ui-avatars.com/api/?name=${first!.username}&background=random',
            isGold: true,
          ),
        const SizedBox(width: 12),
        if (third != null)
          _buildPodiumPlace(
            context,
            name: third!.username,
            color: AppColors.secondaryPurple,
            height: 120,
            rank: 3,
            avatarUrl: third!.profileImageUrl.isNotEmpty
                ? third!.profileImageUrl
                : 'https://ui-avatars.com/api/?name=${third!.username}&background=random',
          ),
      ],
    );
  }

  Widget _buildPodiumPlace(
    BuildContext context, {
    required String name,
    required Color color,
    required double height,
    required int rank,
    required String avatarUrl,
    bool isGold = false,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // User Avatar
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isGold ? Colors.yellow.shade700 : Colors.white,
              width: 3.0,
            ),
          ),
          child: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(avatarUrl),
            backgroundColor: color.withOpacity(0.8),
            onBackgroundImageError: (_, __) {
              // Handle image error silently, maybe show a placeholder icon
            },
          ),
        ),

        // Podium Bar
        Container(
          width: 80,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 5,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            children: [
              Text(
                '$rank',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                name.split(" ")[0], // Use first name only
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const Text("🏆", style: TextStyle(fontSize: 24)),
            ],
          ),
        ),
      ],
    );
  }
}

class LeaderboardListItem extends StatelessWidget {
  final int rank;
  final String title;
  final int points;
  final bool isUser;

  const LeaderboardListItem({
    super.key,
    required this.rank,
    required this.title,
    required this.points,
    this.isUser = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color rankColor = isUser ? AppColors.accentPink : AppColors.darkText;

    return Container(
      decoration: BoxDecoration(
        color: isUser ? AppColors.primaryPurple.withOpacity(0.15) : null,
        borderRadius: BorderRadius.circular(10),
        border: isUser
            ? Border.all(color: AppColors.primaryPurple, width: 2)
            : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 2.0,
        ),

        // Rank Number
        leading: SizedBox(
          width: 30,
          child: Text(
            '$rank',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: rankColor,
            ),
          ),
        ),

        // User Avatar
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primaryPurple,
              child: Text(
                title.isNotEmpty ? title[0].toUpperCase() : '?',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(width: 12),

            // User Name
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isUser ? FontWeight.bold : FontWeight.w500,
                  color: isUser
                      ? AppColors.primaryPurple
                      : Theme.of(context).textTheme.bodyLarge?.color,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),

        // Points
        trailing: Text(
          "$points pts",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryPurple,
          ),
        ),
      ),
    );
  }
}
