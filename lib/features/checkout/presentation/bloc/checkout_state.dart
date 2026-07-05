import 'package:equatable/equatable.dart';

import '../../domain/entities/order_entity.dart';

/// Base class for checkout states.
abstract class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object> get props => [];
}

/// Initial state before checkout is initialized.
class CheckoutInitial extends CheckoutState {
  const CheckoutInitial();
}

/// State when placing an order is in progress.
class CheckoutLoading extends CheckoutState {
  const CheckoutLoading();
}

/// State when an order has been successfully placed.
class CheckoutSuccess extends CheckoutState {
  final OrderEntity order;

  const CheckoutSuccess({required this.order});

  @override
  List<Object> get props => [order];
}

/// State when there is an error placing an order.
class CheckoutError extends CheckoutState {
  final String message;

  const CheckoutError({required this.message});

  @override
  List<Object> get props => [message];
}

/// Initial state before orders are loaded.
class OrdersInitial extends CheckoutState {
  const OrdersInitial();
}

/// State when orders are being loaded.
class OrdersLoading extends CheckoutState {
  const OrdersLoading();
}

/// State when orders have been loaded successfully.
class OrdersLoaded extends CheckoutState {
  final List<OrderEntity> orders;

  const OrdersLoaded({required this.orders});

  @override
  List<Object> get props => [orders];
}

/// State when there is an error loading orders.
class OrdersError extends CheckoutState {
  final String message;

  const OrdersError({required this.message});

  @override
  List<Object> get props => [message];
}
