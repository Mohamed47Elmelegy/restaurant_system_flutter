import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/home_repository.dart';
import 'category_items_state.dart';

class CategoryItemsCubit extends Cubit<CategoryItemsState> {
  final HomeRepository _homeRepository;

  CategoryItemsCubit({required HomeRepository homeRepository})
    : _homeRepository = homeRepository,
      super(CategoryItemsInitial());

  Future<void> loadCategory(int categoryId) async {
    emit(CategoryItemsLoading());
    final result = await _homeRepository.getProductsByCategory(categoryId);
    result.fold(
      (failure) => emit(CategoryItemsError(failure.message)),
      (products) => emit(CategoryItemsLoaded(products)),
    );
  }
}
