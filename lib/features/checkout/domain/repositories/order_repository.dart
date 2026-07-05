import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/order_entity.dart';

/// Abstract repository for order operations.
///
/// This is the contract that the data layer must implement.
abstract class OrderRepository {
  /// Places a new order and returns the created order.
  Future<Either<Failure, OrderEntity>> placeOrder(OrderEntity order);

  /// Retrieves all orders for the current user.
  Future<Either<Failure, List<OrderEntity>>> getOrders();

  /// Clears all order history.
  Future<Either<Failure, void>> clearOrders();
}
