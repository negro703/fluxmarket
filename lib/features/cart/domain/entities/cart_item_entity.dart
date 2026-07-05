import 'package:equatable/equatable.dart';

import '../../../home/domain/entities/product_entity.dart';

/// Represents a cart item containing a product and its quantity.
class CartItemEntity extends Equatable {
  final ProductEntity product;
  final int quantity;

  const CartItemEntity({required this.product, required this.quantity});

  /// Creates a new [CartItemEntity] with the given fields replaced.
  CartItemEntity copyWith({ProductEntity? product, int? quantity}) {
    return CartItemEntity(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [product, quantity];
}
