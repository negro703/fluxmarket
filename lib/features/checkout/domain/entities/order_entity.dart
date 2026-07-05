import 'package:equatable/equatable.dart';

import '../../../cart/domain/entities/cart_item_entity.dart';

/// Represents a completed order in the system.
class OrderEntity extends Equatable {
  final String id;
  final List<CartItemEntity> items;
  final double subtotal;
  final double tax;
  final double total;
  final String deliveryAddress;
  final String deliveryPhone;
  final String paymentMethod;
  final DateTime createdAt;
  final String? status;

  const OrderEntity({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.deliveryAddress,
    required this.deliveryPhone,
    required this.paymentMethod,
    required this.createdAt,
    this.status = 'completed',
  });

  @override
  List<Object?> get props => [
    id,
    items,
    subtotal,
    tax,
    total,
    deliveryAddress,
    deliveryPhone,
    paymentMethod,
    createdAt,
    status,
  ];
}
