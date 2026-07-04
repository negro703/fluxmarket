import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/cart_item_entity.dart';
import '../repositories/cart_repository.dart';

/// Input parameters for the [RemoveFromCartUseCase].
class RemoveFromCartParams {
  final int productId;

  const RemoveFromCartParams({required this.productId});
}

/// Use case for removing a product from the cart.
@LazySingleton()
class RemoveFromCartUseCase {
  final CartRepository _repository;

  RemoveFromCartUseCase(this._repository);

  Future<Either<Failure, List<CartItemEntity>>> call(
      RemoveFromCartParams params) {
    return _repository.removeFromCart(productId: params.productId);
  }
}