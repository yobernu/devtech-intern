import 'package:bloc/bloc.dart';
import 'package:quizapp/features/domain/usecases/questions/get_categories_usecase.dart';
import 'package:quizapp/features/domain/usecases/questions/get_categorynamebyid.dart';
import 'package:quizapp/features/presentation/provider/categories/categories_event.dart';
import 'package:quizapp/features/presentation/provider/categories/categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final GetCategoriesUsecase getCategoriesUsecase;
  final GetCategoryNameByIdUsecase getCategoryNameByIdUsecase;

  CategoriesBloc({
    required this.getCategoriesUsecase,
    required this.getCategoryNameByIdUsecase,
  }) : super(CategoriesInitialState()) {
    on<GetCategoriesEvent>(_onGetCategories);
    on<GetCategoryNameByIdEvent>(_onGetCategoryNameById);
  }

  Future<void> _onGetCategories(
    GetCategoriesEvent event,
    Emitter<CategoriesState> emit,
  ) async {
    emit(CategoriesLoadingState());

    final result = await getCategoriesUsecase.call(GetCategoriesParams());

    emit(
      result.fold(
        (failure) => CategoriesFailureState(failure),
        (categories) => CategoriesLoadedState(categories),
      ),
    );
  }

  Future<void> _onGetCategoryNameById(
    GetCategoryNameByIdEvent event,
    Emitter<CategoriesState> emit,
  ) async {
    emit(CategoriesLoadingState());

    final result = await getCategoryNameByIdUsecase.call(
      GetCategoryNameByIdParams(id: event.id),
    );

    emit(
      result.fold(
        (failure) => CategoriesFailureState(failure),
        (categoryName) => CategoriesLoadedNameState(categoryName),
      ),
    );
  }
}
