import 'package:quizapp/features/domain/entities/leaderboard_entity.dart';

class LeaderboardModel extends LeaderboardEntry {
  LeaderboardModel({
    required super.userId,
    required super.username,
    required super.profileImageUrl,
    required super.score,
    required super.rank,
  });

  factory LeaderboardModel.fromJson(Map<String, dynamic> json, int rank) {
    return LeaderboardModel(
      userId: json['id'] ?? '',
      username: json['username'] ?? 'Unknown',
      profileImageUrl: json['avatar_url'] ?? '',
      score: json['score'] ?? 0,
      rank: rank,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': userId,
      'username': username,
      'avatar_url': profileImageUrl,
      'score': score,
      'rank': rank,
    };
  }
}
