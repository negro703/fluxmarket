import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/cart_item_entity.dart';
import '../../domain/usecases/add_to_cart_usecase.dart';
import '../../domain/usecases/clear_cart_usecase.dart';
import '../../domain/usecases/get_cart_items_usecase.dart';
import '../../domain/usecases/remove_from_cart_usecase.dart';
import '../../domain/usecases/update_quantity_usecase.dart';
import 'cart_event.dart';
import 'cart_state.dart';

/// BLoC that manages the shopping cart state.
///
/// Handles [AddToCartEvent], [RemoveFromCartEvent], [DecrementQuantityEvent],
/// [UpdateQuantityEvent], [LoadCartEvent], and [ClearCartEvent] to manage
/// the cart lifecycle.
/// Computes subtotal, tax (8%), and total for the [CartLoaded] state.
@LazySingleton()
class CartBloc extends Bloc<CartEvent, CartState> {
  final AddToCartUseCase _addToCartUseCase;
  final RemoveFromCartUseCase _removeFromCartUseCase;
  final GetCartItemsUseCase _getCartItemsUseCase;
  final ClearCartUseCase _clearCartUseCase;
  final UpdateQuantityUseCase _updateQuantityUseCase;

  static const double _taxRate = 0.08;

  CartBloc(
    this._addToCartUseCase,
    this._removeFromCartUseCase,
    this._getCartItemsUseCase,
    this._clearCartUseCase,
    this._updateQuantityUseCase,
  ) : super(const CartState.initial()) {
    on<LoadCartEvent>(_onLoadCart);
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<DecrementQuantityEvent>(_onDecrementQuantity);
    on<UpdateQuantityEvent>(_onUpdateQuantity);
    on<ClearCartEvent>(_onClearCart);
  }

  Future<void> _onLoadCart(
    LoadCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartState.loading());

    final result = await _getCartItemsUseCase();

    result.fold(
      (failure) => emit(CartState.error(message: failure.message)),
      (items) => _emitCartState(emit, items),
    );
  }

  Future<void> _onAddToCart(
    AddToCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartState.loading());

    final result = await _addToCartUseCase(
      AddToCartParams(item: event.item),
    );

    result.fold(
      (failure) => emit(CartState.error(message: failure.message)),
      (items) => _emitCartState(emit, items),
    );
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartState.loading());

    final result = await _removeFromCartUseCase(
      RemoveFromCartParams(productId: event.productId),
    );

    result.fold(
      (failure) => emit(CartState.error(message: failure.message)),
      (items) => _emitCartState(emit, items),
    );
  }

  Future<void> _onDecrementQuantity(
    DecrementQuantityEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      final currentItems = await _removeFromCartUseCase(
        RemoveFromCartParams(productId: event.productId),
      );

      currentItems.fold(
        (failure) => emit(CartState.error(message: failure.message)),
        (items) => _emitCartState(emit, items),
      );
    } catch (e) {
      emit(CartState.error(message: e.toString()));
    }
  }

  Future<void> _onUpdateQuantity(
    UpdateQuantityEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      final currentItems = await _updateQuantityUseCase(
        UpdateQuantityParams(
          productId: event.productId,
          newQuantity: event.newQuantity,
        ),
      );

      currentItems.fold(
        (failure) => emit(CartState.error(message: failure.message)),
        (items) => _emitCartState(emit, items),
      );
    } catch (e) {
      emit(CartState.error(message: e.toString()));
    }
  }

  Future<void> _onClearCart(
    ClearCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartState.loading());

    final result = await _clearCartUseCase();

    result.fold(
      (failure) => emit(CartState.error(message: failure.message)),
      (_) => emit(const CartState.empty()),
    );
  }

  /// Emits either [CartEmpty] or [CartLoaded] based on the items list,
  /// computing subtotal, tax, and total.
  void _emitCartState(Emitter<CartState> emit, List<CartItemEntity> items) {
    if (items.isEmpty) {
      emit(const CartState.empty());
      return;
    }

    final subtotal = items.fold<double>(
      0.0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
    final tax = subtotal * _taxRate;
    final total = subtotal + tax;

    emit(CartState.loaded(
      items: items,
      subtotal: subtotal,
      tax: tax,
      total: total,
    ));
  }
}