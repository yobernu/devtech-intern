import 'package:quizapp/features/data/models/question_model.dart';
import 'package:quizapp/features/data/models/quiz_categogry_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class RemoteQuizDataSource {
  Future<List<QuizCategoryModel>> getCategories();
  Future<List<QuestionModel>> getQuestions(
    String categoryId,
    String difficulty,
  );
}

class RemoteQuizDataSourceImpl implements RemoteQuizDataSource {
  final SupabaseClient supabase;

  RemoteQuizDataSourceImpl(this.supabase);

  @override
  Future<List<QuizCategoryModel>> getCategories() async {
    final response = await supabase.from('categories').select().order('name');
    return (response as List)
        .map((item) => QuizCategoryModel.fromJson(item))
        .toList();
  }

  @override
  Future<List<QuestionModel>> getQuestions(
    String categoryId,
    String difficulty,
  ) async {
    final response = await supabase
        .from('questions')
        .select()
        .eq('category_id', categoryId)
        .eq('difficulty', difficulty)
        .limit(8)
        .order('created_at', ascending: false);

    return (response as List)
        .map((item) => QuestionModel.fromJson(item))
        .toList();
  }
}
