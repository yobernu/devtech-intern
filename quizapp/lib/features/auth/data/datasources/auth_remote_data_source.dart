import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';
import 'package:quizapp/core/constants/auth_services.dart';
import 'package:quizapp/core/errors/exceptions.dart'; // Ensure this class exists
import 'package:quizapp/core/errors/failures.dart';
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
  Future<bool> isAuthenticated();
  Future<UserEntity> refreshToken();
  Future<UserEntity> updateProfile({
    required String name,
    required String email,
    required String password,
  });
  Future<UserEntity> updateProfilePicture({required String imageUrl});
}

class AuthRemoteDataSourceImpl implements RemoteAuthDataSource {
  static final auth = AuthService.auth;
  static final supabase = AuthService.supabase;
  final http.Client client;

  AuthRemoteDataSourceImpl(this.client);

  // Helper method to convert DB response to UserEntity
  UserEntity _mapProfileData(Map<String, dynamic> profileData) {
    return UserEntity(
      id: profileData['id'],
      email: profileData['email'],
      username: profileData['username'],
      profileImageUrl: profileData['avatar_url'] ?? '',
      experiencePoints: profileData['experience_points'] ?? 0,
      rank: profileData['rank_title'] ?? 'Beginner',
      score: profileData['score'] ?? 0,
      joinDate:
          DateTime.tryParse(profileData['created_at'] ?? '') ?? DateTime.now(),
      friends: List<String>.from(profileData['friends'] ?? []),
      categoryStats: Map<String, int>.from(profileData['category_stats'] ?? {}),
    );
  }

  @override
  Future<UserEntity> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse authResponse = await auth.signUp(
        email: email,
        password: password,
        data: {'username': name},
      );

      final User? user = authResponse.user;

      if (user != null) {
        await supabase.from('profiles').upsert({
          'id': user.id,
          'email': email,
          'username': name,
          'leaderboard_rank': 9999,
          'score': 0,
          'experience_points': 0,
          'rank_title': 'Beginner',
          'avatar_url': user.userMetadata?['avatar_url'],
        });

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
        throw ServerException('Sign up failed, user object is null.');
      }
    } on AuthException catch (e) {
      throw ServerException('Sign up failed: ${e.message}');
    } on PostgrestException catch (e) {
      throw ServerException('Profile creation failed: ${e.message}');
    } catch (e) {
      throw ServerException('An unexpected error occurred during sign up: $e');
    }
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    final User? user = auth.currentUser;

    if (user == null) {
      throw ServerException('No authenticated user session found.');
    }

    try {
      final response = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      return _mapProfileData(response);
    } on PostgrestException catch (e) {
      throw ServerException('Failed to fetch user profile: ${e.message}');
    } catch (e) {
      throw ServerException('Failed to get current user: $e');
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
        throw ServerException('Sign in failed, user object is null.');
      }
    } on AuthException catch (e) {
      throw ServerException('Sign in failed: ${e.message}');
    } catch (e) {
      throw ServerException('An unexpected error occurred during sign in: $e');
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
      // Return a basic, empty UserEntity indicating sign-out success
      return UserEntity(
        id: '',
        email: '',
        username: '',
        profileImageUrl: '',
        experiencePoints: 0,
        rank: '',
        score: 0,
        joinDate: DateTime.now(),
        friends: [],
        categoryStats: {},
      );
    } on AuthException catch (e) {
      throw ServerException('Failed to sign out: ${e.message}');
    } catch (e) {
      throw ServerException('An unexpected error occurred during sign out: $e');
    }
  }

  @override
  Future<UserEntity> refreshToken() async {
    try {
      // Supabase handles token refresh automatically. We can ensure the session
      // is up to date and then fetch the current user details.
      final AuthResponse response = await auth.refreshSession();

      if (response.user != null) {
        return await getCurrentUser();
      } else {
        throw ServerException('Failed to refresh authentication token.');
      }
    } on AuthException catch (e) {
      throw ServerException(e.message ?? 'Token refresh failed.');
    } catch (e) {
      throw ServerException(
        'An unexpected error occurred during token refresh: $e',
      );
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    return auth.currentUser != null;
  }

  @override
  Future<UserEntity> updateProfile({
    required String name,
    required String email,
    required String password,
  }) async {
    final User? user = auth.currentUser;
    if (user == null) {
      throw ServerException('No authenticated user found.');
    }

    try {
      // 1. Update the 'profiles' table for username
      await supabase
          .from('profiles')
          .update({'username': name})
          .eq('id', user.id);

      // 2. Update the auth metadata (good practice for username display)
      await auth.updateUser(UserAttributes(data: {'username': name}));

      // We ignore email/password updates here as they are handled by dedicated methods.

      // 3. Get the latest user entity
      return await getCurrentUser();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } on AuthException catch (e) {
      throw ServerException(
        e.message ?? 'Authentication error during profile update.',
      );
    } catch (e) {
      throw ServerException(
        'An unexpected error occurred during profile update: $e',
      );
    }
  }

  @override
  Future<UserEntity> updateProfilePicture({required String imageUrl}) async {
    final User? user = auth.currentUser;
    if (user == null) {
      throw ServerException('No authenticated user found.');
    }

    try {
      // 1. Update the 'profiles' table with the new image URL
      await supabase
          .from('profiles')
          .update({'avatar_url': imageUrl})
          .eq('id', user.id);

      // 2. Get the latest user entity
      return await getCurrentUser();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(
        'An unexpected error occurred during profile picture update: $e',
      );
    }
  }
}
