import 'dart:io';
import 'package:quizapp/core/constants/auth_services.dart';
import 'package:quizapp/features/auth/domain/entity/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class RemoteAuthDataSource {
  Future<UserEntity> signUp({
    required String name,
    required String email,
    required String password,
  });
  Future<UserEntity> signIn({required String email, required String password});
  Future<UserEntity> signOut();
  Future<UserEntity> signInWithGoogle();
  Future<UserEntity> getCurrentUser();
}

class AuthRemoteDataSource implements RemoteAuthDataSource {
  static final auth = AuthService.auth;
  static final supabase = AuthService.supabase;
  final HttpClient client;

  AuthRemoteDataSource(this.client);

  @override
  Future<UserEntity> getCurrentUser() async {
    final User? user = auth.currentUser;

    if (user == null) {
      throw Exception('No authenticated user session found.');
    }

    try {
      final response = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      final Map<String, dynamic> profileData = response;

      return UserEntity(
        id: profileData['id'],
        email: profileData['email'],
        username: profileData['username'],
        profileImageUrl: profileData['avatar_url'] ?? '',
        experiencePoints: profileData['experience_points'] ?? 0,
        rank: profileData['rank_title'] ?? 'Beginner',
        score: profileData['score'] ?? 0,
        joinDate:
            DateTime.tryParse(profileData['created_at'] ?? '') ??
            DateTime.now(),
        friends: List<String>.from(profileData['friends'] ?? []),
        categoryStats: Map<String, int>.from(
          profileData['category_stats'] ?? {},
        ),
      );
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch user profile: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get current user: $e');
    }
  }

  @override
  Future<UserEntity> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse response = await auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        return await getCurrentUser();
      } else {
        throw Exception('Sign in failed, user object is null.');
      }
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  @override
  Future<UserEntity> signInWithGoogle() {
    // TODO: implement signInWithGoogle
    throw UnimplementedError();
  }

  @override
  Future<UserEntity> signOut() async {
    try {
      await auth.signOut();
      return UserEntity(
        id: '',
        email: '',
        username: '',
        // Provide initial values for all required fields in your UserEntity
        profileImageUrl: '',
        experiencePoints: 0,
        rank: '',
        score: 0,
        joinDate: DateTime.now(),
        friends: [],
        categoryStats: {},
      );
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  @override
  Future<UserEntity> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // 1. Authenticate the user (creates entry in auth.users)
      final AuthResponse authResponse = await auth.signUp(
        email: email,
        password: password,
        // Optionally pass username as metadata for immediate display
        data: {'username': name},
      );

      final User? user = authResponse.user;

      if (user != null) {
        // 2. Insert the initial profile data into the public 'profiles' table
        await supabase.from('profiles').insert({
          'id': user.id,
          'email': email,
          'username': name,
          'leaderboard_rank': 9999, // Use default from SQL definition
          'score': 0, // Use default from SQL definition
          'experience_points': 0, // Use default from SQL definition
          'rank_title': 'Beginner', // Use default from SQL definition
        });

        // 3. Return the newly created user entity
        return UserEntity(
          id: user.id,
          email: user.email!,
          username: name,
          profileImageUrl: '',
          experiencePoints: 0,
          rank: 'Beginner',
          score: 0,
          joinDate: DateTime.now(),
          friends: [],
          categoryStats: {},
        );
      } else {
        throw Exception('Sign up failed, user object is null.');
      }
    } catch (e) {
      // Handle potential 'User already registered' or network errors
      throw Exception('Failed to sign up: $e');
    }
  }
}
