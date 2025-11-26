import 'package:quizapp/features/data/models/quiz_categogry_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class RemoteCategoriesDatasource {
  Future<List<QuizCategoryModel>> getAllCategories();
  Future<String?> getCategoryNameById(String categoryId);
}

class RemoteCategoriesDatasourceImpl implements RemoteCategoriesDatasource {
  final SupabaseClient supabase;
  RemoteCategoriesDatasourceImpl(this.supabase);

  @override
  Future<List<QuizCategoryModel>> getAllCategories() async {
    final response = await supabase.from('categories').select().order('name');
    return (response as List)
        .map((item) => QuizCategoryModel.fromJson(item))
        .toList();
  }

  @override
  Future<String?> getCategoryNameById(String categoryId) async {
    final response = await supabase
        .from('categories')
        .select('name')
        .eq('id', categoryId)
        .maybeSingle();

    if (response != null) {
      return response['name'] as String;
    }
    return null;
  }
}
