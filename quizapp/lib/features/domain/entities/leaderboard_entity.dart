class LeaderboardEntry {
  final String userId;
  final String username;
  final String profileImageUrl;
  final int score;
  final int rank;

  LeaderboardEntry({
    required this.userId,
    required this.username,
    required this.profileImageUrl,
    required this.score,
    required this.rank,
  });
}
