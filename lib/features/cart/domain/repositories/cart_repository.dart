import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/cart_item_entity.dart';

/// Abstract repository for cart operations.
///
/// This is the contract that the domain layer defines and the data layer
/// implements, following Clean Architecture's dependency inversion principle.
abstract class CartRepository {
  /// Adds a product to the cart. If the product already exists, increments
  /// the quantity by [quantity] (default 1).
  Future<Either<Failure, List<CartItemEntity>>> addToCart({
    required CartItemEntity item,
  });

  /// Removes a product from the cart entirely by [productId].
  Future<Either<Failure, List<CartItemEntity>>> removeFromCart({
    required int productId,
  });

  /// Decrements the quantity of a product by 1. If quantity reaches 0,
  /// removes the item from the cart.
  Future<Either<Failure, List<CartItemEntity>>> decrementQuantity({
    required int productId,
  });

  /// Returns all items currently in the cart.
  Future<Either<Failure, List<CartItemEntity>>> getCartItems();

  /// Clears all items from the cart.
  Future<Either<Failure, void>> clearCart();

  /// Returns the total number of items in the cart (sum of quantities).
  Future<int> getItemCount();
}