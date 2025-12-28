import 'dart:convert';
import 'package:quizapp/core/errors/exceptions.dart';
import 'package:quizapp/features/auth/domain/entity/user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String CACHED_USER_KEY = 'cached_user';

abstract class LocalAuthDataSource {
  /// Cache user data to local storage
  Future<void> cacheUser(UserEntity user);

  /// Retrieve cached user data
  Future<UserEntity> getCachedUser();

  /// Clear cached user data (on logout)
  Future<void> clearCache();

  /// Check if user data is cached
  Future<bool> hasCache();
}

class LocalAuthDataSourceImpl implements LocalAuthDataSource {
  final SharedPreferences sharedPreferences;

  const LocalAuthDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheUser(UserEntity user) async {
    final jsonString = json.encode(user.toJson());
    await sharedPreferences.setString(CACHED_USER_KEY, jsonString);
  }

  @override
  Future<UserEntity> getCachedUser() async {
    final jsonString = sharedPreferences.getString(CACHED_USER_KEY);

    if (jsonString != null && jsonString.isNotEmpty) {
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      return UserEntity.fromJson(jsonMap);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> clearCache() async {
    await sharedPreferences.remove(CACHED_USER_KEY);
  }

  @override
  Future<bool> hasCache() async {
    return sharedPreferences.containsKey(CACHED_USER_KEY);
  }
}
