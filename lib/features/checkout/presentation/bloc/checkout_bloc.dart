import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../cart/domain/entities/cart_item_entity.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/usecases/place_order_usecase.dart';
import '../../domain/usecases/get_orders_usecase.dart';
import 'checkout_event.dart';
import 'checkout_state.dart';

/// BLoC that manages checkout and order history state.
///
/// Handles [PlaceOrderEvent] and [LoadOrdersEvent] for managing
/// the checkout process and viewing past orders.
@LazySingleton()
class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final PlaceOrderUseCase _placeOrderUseCase;
  final GetOrdersUseCase _getOrdersUseCase;

  // Store cart data temporarily during checkout
  List<CartItemEntity> _cartItems = [];
  double _subtotal = 0;
  double _tax = 0;
  double _total = 0;

  CheckoutBloc(this._placeOrderUseCase, this._getOrdersUseCase)
    : super(const CheckoutInitial()) {
    on<InitializeCheckoutEvent>(_onInitializeCheckout);
    on<PlaceOrderEvent>(_onPlaceOrder);
    on<LoadOrdersEvent>(_onLoadOrders);
  }

  void _onInitializeCheckout(
    InitializeCheckoutEvent event,
    Emitter<CheckoutState> emit,
  ) {
    _cartItems = event.items;
    _subtotal = event.subtotal;
    _tax = event.tax;
    _total = event.total;
    emit(const CheckoutInitial());
  }

  Future<void> _onPlaceOrder(
    PlaceOrderEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(const CheckoutLoading());

    // Simulate mock payment processing with 2 second delay
    try {
      await processMockPayment(event.paymentMethod);
    } catch (e) {
      emit(CheckoutError(message: 'Payment processing failed'));
      return;
    }

    final order = OrderEntity(
      id: 'order_${DateTime.now().millisecondsSinceEpoch}',
      items: _cartItems,
      subtotal: _subtotal,
      tax: _tax,
      total: _total,
      deliveryAddress: event.address,
      deliveryPhone: event.phone,
      paymentMethod: event.paymentMethod,
      createdAt: DateTime.now(),
    );

    final result = await _placeOrderUseCase(PlaceOrderParams(order: order));

    result.fold(
      (failure) => emit(CheckoutError(message: failure.message)),
      (order) => emit(CheckoutSuccess(order: order)),
    );
  }

  /// Simulates mock payment processing with configurable delay.
  Future<bool> processMockPayment(String paymentMethod) async {
    // In production, this would call a payment gateway API
    await Future<void>.delayed(const Duration(milliseconds: 800));
    // Simulate 95% success rate
    return true;
  }

  Future<void> _onLoadOrders(
    LoadOrdersEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(const OrdersLoading());

    final result = await _getOrdersUseCase();

    result.fold(
      (failure) => emit(OrdersError(message: failure.message)),
      (orders) => emit(OrdersLoaded(orders: orders)),
    );
  }
}
