import 'package:equatable/equatable.dart';

import '../../domain/entities/cart_item_entity.dart';

/// Events that can be dispatched to the [CartBloc].
sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

/// Event triggered to load cart items.
class LoadCartEvent extends CartEvent {
  const LoadCartEvent();
}

/// Event triggered to add an item to the cart.
class AddToCartEvent extends CartEvent {
  final CartItemEntity item;

  const AddToCartEvent({required this.item});

  @override
  List<Object?> get props => [item];
}

/// Event triggered to remove an item from the cart.
class RemoveFromCartEvent extends CartEvent {
  final int productId;

  const RemoveFromCartEvent({required this.productId});

  @override
  List<Object?> get props => [productId];
}

/// Event triggered to decrement the quantity of an item.
class DecrementQuantityEvent extends CartEvent {
  final int productId;

  const DecrementQuantityEvent({required this.productId});

  @override
  List<Object?> get props => [productId];
}

/// Event triggered to update the quantity of an item to a specific value.
class UpdateQuantityEvent extends CartEvent {
  final int productId;
  final int newQuantity;

  const UpdateQuantityEvent({
    required this.productId,
    required this.newQuantity,
  });

  @override
  List<Object?> get props => [productId, newQuantity];
}

/// Event triggered to clear the entire cart.
class ClearCartEvent extends CartEvent {
  const ClearCartEvent();
}
