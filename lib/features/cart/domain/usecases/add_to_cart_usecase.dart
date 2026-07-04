import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/cart_item_entity.dart';
import '../repositories/cart_repository.dart';

/// Input parameters for the [AddToCartUseCase].
class AddToCartParams {
  final CartItemEntity item;

  const AddToCartParams({required this.item});
}

/// Use case for adding a product to the cart.
@LazySingleton()
class AddToCartUseCase {
  final CartRepository _repository;

  AddToCartUseCase(this._repository);

  Future<Either<Failure, List<CartItemEntity>>> call(AddToCartParams params) {
    return _repository.addToCart(item: params.item);
  }
}