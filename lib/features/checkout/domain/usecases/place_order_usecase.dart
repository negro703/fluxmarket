import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';

/// Parameters for the [PlaceOrderUseCase].
class PlaceOrderParams {
  final OrderEntity order;

  const PlaceOrderParams({required this.order});
}

/// Use case for placing an order.
///
/// Takes an [OrderEntity] and persists it using the [OrderRepository].
@LazySingleton()
class PlaceOrderUseCase {
  final OrderRepository repository;

  PlaceOrderUseCase(this.repository);

  Future<Either<Failure, OrderEntity>> call(PlaceOrderParams params) async {
    return repository.placeOrder(params.order);
  }
}
