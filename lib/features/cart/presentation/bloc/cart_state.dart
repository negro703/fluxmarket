import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/cart_item_entity.dart';

part 'cart_state.freezed.dart';

/// Possible states for the [CartBloc].
@freezed
sealed class CartState with _$CartState {
  const factory CartState.initial() = CartInitial;

  const factory CartState.loading() = CartLoading;

  const factory CartState.loaded({
    required List<CartItemEntity> items,
    required double subtotal,
    required double tax,
    required double total,
  }) = CartLoaded;

  const factory CartState.empty() = CartEmpty;

  const factory CartState.error({required String message}) = CartError;
}