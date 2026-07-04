import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/cart_item_entity.dart';
import '../repositories/cart_repository.dart';

/// Input parameters for the [UpdateQuantityUseCase].
class UpdateQuantityParams {
  final int productId;
  final int newQuantity;

  const UpdateQuantityParams({
    required this.productId,
    required this.newQuantity,
  });
}

/// Use case for updating the quantity of a product in the cart.
@lazySingleton
class UpdateQuantityUseCase {
  final CartRepository _repository;

  UpdateQuantityUseCase(this._repository);

  Future<Either<Failure, List<CartItemEntity>>> call(UpdateQuantityParams params) {
    return _repository.updateQuantity(
      productId: params.productId,
      newQuantity: params.newQuantity,
    );
  }
}