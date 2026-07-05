import 'package:equatable/equatable.dart';

import '../../../cart/domain/entities/cart_item_entity.dart';

/// Base class for checkout events.
abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object> get props => [];
}

/// Event to initialize checkout with cart items.
class InitializeCheckoutEvent extends CheckoutEvent {
  final List<CartItemEntity> items;
  final double subtotal;
  final double tax;
  final double total;

  const InitializeCheckoutEvent({
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
  });

  @override
  List<Object> get props => [items, subtotal, tax, total];
}

/// Event to place an order.
class PlaceOrderEvent extends CheckoutEvent {
  final String address;
  final String phone;
  final String paymentMethod;

  const PlaceOrderEvent({
    required this.address,
    required this.phone,
    required this.paymentMethod,
  });

  @override
  List<Object> get props => [address, phone, paymentMethod];
}

/// Event to load order history.
class LoadOrdersEvent extends CheckoutEvent {
  const LoadOrdersEvent();
}
