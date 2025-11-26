import 'package:quizapp/core/errors/failures.dart';
import 'package:quizapp/features/domain/entities/quiz_category_entity.dart';

class CategoriesState {}

class CategoriesInitialState extends CategoriesState {}

class CategoriesLoadingState extends CategoriesState {}

class CategoriesLoadedState extends CategoriesState {
  final List<QuizCategory> categories; // Renamed property for clarity

  CategoriesLoadedState(this.categories);
}

class CategoriesLoadedNameState extends CategoriesState {
  final String categoryName;

  CategoriesLoadedNameState(this.categoryName);
}

// This state is used if a failure occurs while attempting to fetch categories
class CategoriesFailureState extends CategoriesState {
  final Failure failure;

  CategoriesFailureState(this.failure);
}
