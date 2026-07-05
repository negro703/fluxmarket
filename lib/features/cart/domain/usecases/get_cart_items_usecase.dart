import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/cart_item_entity.dart';
import '../repositories/cart_repository.dart';

/// Use case for retrieving all items in the cart.
@LazySingleton()
class GetCartItemsUseCase {
  final CartRepository _repository;

  GetCartItemsUseCase(this._repository);

  Future<Either<Failure, List<CartItemEntity>>> call() {
    return _repository.getCartItems();
  }
}
