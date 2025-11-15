import 'package:quizapp/features/auth/domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    String? id,
    String? username,
    String? email,
    String? role,
    String? accessToken,
    String? profileImageUrl,
    int? experiencePoints,
    String? rank,
    int? score,
    DateTime? joinDate,
    List<String>? friends,
    Map<String, int>? categoryStats,
  }) : super(
         id: id ?? '0',
         username: username ?? '',
         email: email ?? '',
         role: role ?? '',
         accessToken: accessToken ?? '0',
         profileImageUrl: profileImageUrl ?? '',
         experiencePoints: experiencePoints ?? 0,
         rank: rank ?? '',
         score: score ?? 0,
         joinDate: joinDate ?? DateTime.now(),
         friends: friends ?? [],
         categoryStats: categoryStats ?? {},
       );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id']?.toString() ?? '0',
      username: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '', // optional
      accessToken: json['access_token'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '', // optional
      experiencePoints: json['experiencePoints'] ?? 0, // optional
      rank: json['rank'] ?? '', // optional
      score: json['score'] ?? 0, // optional
      joinDate: json['joinDate'] ?? DateTime.now(), // optional
      friends: json['friends'] ?? [], // optional
      categoryStats: json['categoryStats'] ?? {}, // optional
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'role': role,
      'accessToken': accessToken,
      'username': username,
      'profileImageUrl': profileImageUrl,
      'experiencePoints': experiencePoints,
      'rank': rank,
      'score': score,
      'joinDate': joinDate,
      'friends': friends,
      'categoryStats': categoryStats,
    };
  }
}
