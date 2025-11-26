import 'package:flutter/material.dart';
import 'package:quizapp/core/constants/appcolors.dart';
import 'package:quizapp/features/presentation/helpers/meshBackground.dart';

class LeaderBoardScreen extends StatelessWidget {
  const LeaderBoardScreen({super.key});

  final List<Map<String, dynamic>> items = const [
    {"title": "Grace", "points": 4500},
    {"title": "John", "points": 3200},
    {"title": "Sam", "points": 2850},
    {"title": "Aisha", "points": 2100},
    {"title": "Ben", "points": 1900},
    {"title": "Chloe", "points": 1500},
    {"title": "David", "points": 1000},
    {"title": "Emma", "points": 900},
    {"title": "Frank", "points": 850},
    {"title": "Hannah", "points": 700},
  ];

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent, 
      body: MeshGradientBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 24),
                  child: PodiumWidget(
                    firstName: "Abebe",
                    secondName: "Daniel",
                    thirdName: "Yoseph",
                  ),
                ),
              ),
              SliverToBoxAdapter( 

                 child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Column(
                    children: [
                      ...items.map((item) {
                        final index = items.indexOf(item);
                        final rank = index + 4;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                          child: LeaderboardListItem(
                            rank: rank,
                            title: item["title"]!,
                            points: item["points"]!,
                            isUser: item["title"] == "John",
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        ),
      ),
    );
  }
}

class PodiumWidget extends StatelessWidget {
  final String firstName;
  final String secondName;
  final String thirdName;

  const PodiumWidget({
    super.key,
    required this.firstName,
    required this.secondName,
    required this.thirdName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildPodiumPlace(
          context,
          name: secondName,
          color: AppColors.smallButtonBlue,
          height: 150,
          rank: 2,
          avatarUrl:
              'https://plus.unsplash.com/premium_photo-1690407617542-2f210cf20d7e?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        ),
        const SizedBox(width: 12),

        _buildPodiumPlace(
          context,
          name: firstName,
          color: AppColors.primaryPurple,
          height: 180,
          rank: 1,
          avatarUrl:
              'https://plus.unsplash.com/premium_photo-1690407617542-2f210cf20d7e?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
          isGold: true,
        ),
        const SizedBox(width: 12),

        _buildPodiumPlace(
          context,
          name: thirdName,
          color: AppColors.secondaryPurple,
          height: 120,
          rank: 3,
          avatarUrl:
              'https://plus.unsplash.com/premium_photo-1690407617542-2f210cf20d7e?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
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

              Text("🏆", style: TextStyle(fontSize: 24)),
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
        color: isUser
            ? AppColors.primaryPurple.withOpacity(0.15)
            : null,
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
                title[0].toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(width: 12),

            // User Name
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isUser ? FontWeight.bold : FontWeight.w500,
                color: isUser
                    ? AppColors.primaryPurple
                    : Theme.of(context).textTheme.bodyLarge?.color,
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
