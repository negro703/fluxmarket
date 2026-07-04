import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/get_products_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

/// BLoC that manages the home/product listing state.
///
/// Handles [FetchProductsEvent] to load products from the API.
@LazySingleton()
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetProductsUseCase _getProductsUseCase;

  HomeBloc(this._getProductsUseCase) : super(const HomeState.initial()) {
    on<FetchProductsEvent>(_onFetchProducts);
  }

  /// Handles the [FetchProductsEvent] by calling the [GetProductsUseCase].
  Future<void> _onFetchProducts(
    FetchProductsEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeState.loading());

    final result = await _getProductsUseCase();

    result.fold(
      (failure) => emit(HomeState.error(message: failure.message)),
      (products) => emit(HomeState.loaded(products: products)),
    );
  }
}