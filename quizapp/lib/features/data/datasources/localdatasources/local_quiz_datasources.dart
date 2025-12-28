import 'dart:convert';
import 'package:quizapp/core/errors/exceptions.dart';
import 'package:quizapp/features/data/models/question_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String CACHED_QUESTIONS_KEY = "Questions";
const String USER_SCORE_KEY = "score";

abstract class LocalQuizDatasources {
  Future<void> cacheQuestions(List<QuestionModel> questions);
  Future<List<QuestionModel>> getCachedQuestions();
  Future<int> getUserScore();
  Future<void> cacheUserScore(int score);
}

class LocalQuizDataSourcesImpl implements LocalQuizDatasources {
  final SharedPreferences sharedPreferences;
  const LocalQuizDataSourcesImpl(this.sharedPreferences);

  @override
  Future<void> cacheQuestions(List<QuestionModel> questions) async {
    final List<Map<String, dynamic>> jsonList = questions
        .map((question) => question.toJson())
        .toList();

    final String jsonString = json.encode(jsonList);
    await sharedPreferences.setString(CACHED_QUESTIONS_KEY, jsonString);
  }

  @override
  Future<List<QuestionModel>> getCachedQuestions() async {
    final String? jsonString = sharedPreferences.getString(
      CACHED_QUESTIONS_KEY,
    );

    if (jsonString != null && jsonString.isNotEmpty) {
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;

      final List<QuestionModel> questions = jsonList
          .map(
            (jsonMap) =>
                QuestionModel.fromJson(jsonMap as Map<String, dynamic>),
          )
          .toList();
      return questions;
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheUserScore(int score) async {
    await sharedPreferences.setInt(USER_SCORE_KEY, score);
  }

  @override
  Future<int> getUserScore() async {
    final int score = sharedPreferences.getInt(USER_SCORE_KEY) ?? 0;
    return score;
  }
}
