import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../repositories/cart_repository.dart';

/// Use case for clearing all items from the cart.
@LazySingleton()
class ClearCartUseCase {
  final CartRepository _repository;

  ClearCartUseCase(this._repository);

  Future<Either<Failure, void>> call() {
    return _repository.clearCart();
  }
}
