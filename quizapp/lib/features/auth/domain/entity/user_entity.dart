class UserEntity {
  final String id;
  final String email;
  final String username;
  final String? profileImageUrl;
  final String? accessToken;
  final String? refreshToken;
  final String? role;
  final int experiencePoints;
  final String rank;
  final int score;
  final DateTime joinDate;
  final List<String> friends;
  final Map<String, int> categoryStats;

  UserEntity({
    required this.id,
    required this.email,
    required this.username,
    this.profileImageUrl,
    this.accessToken,
    this.refreshToken,
    this.role,
    required this.experiencePoints,
    required this.rank,
    required this.score,
    required this.joinDate,
    required this.friends,
    required this.categoryStats,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      profileImageUrl: json['profileImageUrl'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      role: json['role'],
      experiencePoints: json['experiencePoints'],
      rank: json['rank'],
      score: json['score'],
      joinDate: DateTime.parse(json['joinDate']),
      friends: List<String>.from(json['friends']),
      categoryStats: Map<String, int>.from(json['categoryStats']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'profileImageUrl': profileImageUrl,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'role': role,
      'experiencePoints': experiencePoints,
      'rank': rank,
      'score': score,
      'joinDate': joinDate.toIso8601String(),
      'friends': friends,
      'categoryStats': categoryStats,
    };
  }

  @override
  String toString() {
    return 'UserEntity(id: $id, email: $email, username: $username, profileImageUrl: $profileImageUrl, accessToken: $accessToken, refreshToken: $refreshToken, role: $role, experiencePoints: $experiencePoints, rank: $rank, score: $score, joinDate: $joinDate, friends: $friends, categoryStats: $categoryStats)';
  }
}
