class User {
  final String id;
  final String username;
  final String email;
  final String profileImageUrl;
  final int experiencePoints;
  final String rank; // 'Expert', 'Beginner', etc.
  final int score; // Current score/points
  final DateTime joinDate;
  final List<String> friends;
  final Map<String, int> categoryStats; // Stats per category

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.profileImageUrl,
    required this.experiencePoints,
    required this.rank,
    required this.score,
    required this.joinDate,
    required this.friends,
    required this.categoryStats,
  });
}
