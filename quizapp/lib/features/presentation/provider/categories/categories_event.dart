import 'package:equatable/equatable.dart';

abstract class CategoriesEvent extends Equatable {
  const CategoriesEvent();

  @override
  List<Object?> get props => [];
}

class GetCategoriesEvent extends CategoriesEvent {
  const GetCategoriesEvent();
}

class GetCategoryNameByIdEvent extends CategoriesEvent {
  final String id;

  const GetCategoryNameByIdEvent({required this.id});
}
