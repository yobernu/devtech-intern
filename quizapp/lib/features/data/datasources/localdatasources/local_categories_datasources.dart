import 'dart:convert';

import 'package:quizapp/core/errors/exceptions.dart';
import 'package:quizapp/features/data/models/quiz_categogry_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String CACHED_CATEGORIES_KEY = 'CACHED_CATEGORIES';

abstract class LocalCategoriesDatasources {
  Future<void> cacheCategories(List<QuizCategoryModel> categories);

  Future<List<QuizCategoryModel>> getCachedCategories();
  Future<void> updateCachedCategories(List<QuizCategoryModel> categories);
}

class LocalCategoriesDataSourcesImpl implements LocalCategoriesDatasources {
  final SharedPreferences sharedPreferences;
  const LocalCategoriesDataSourcesImpl(this.sharedPreferences);

  @override
  Future<void> cacheCategories(List<QuizCategoryModel> categories) {
    final List<Map<String, dynamic>> jsonList = categories
        .map((category) => category.toJson())
        .toList();
    final String jsonString = json.encode(jsonList);
    return sharedPreferences.setString(CACHED_CATEGORIES_KEY, jsonString);
  }

  @override
  Future<List<QuizCategoryModel>> getCachedCategories() async {
    final String? jsonString = sharedPreferences.getString(
      CACHED_CATEGORIES_KEY,
    );
    if (jsonString != null && jsonString.isNotEmpty) {
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;

      final List<QuizCategoryModel> categories = jsonList
          .map(
            (jsonMap) =>
                QuizCategoryModel.fromJson(jsonMap as Map<String, dynamic>),
          )
          .toList();
      return categories;
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> updateCachedCategories(List<QuizCategoryModel> categories) {
    return cacheCategories(categories);
  }
}
