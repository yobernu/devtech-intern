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
    print('Datasource: Querying category with ID: $categoryId');

    final response = await supabase
        .from('categories')
        .select('name')
        .eq('id', categoryId)
        .maybeSingle();

    print('Datasource: Response: $response');

    if (response != null) {
      final name = response['name'] as String;
      print('Datasource: Found category name: $name');
      return name;
    }

    print('Datasource: No category found for ID: $categoryId');
    return null;
  }
}
