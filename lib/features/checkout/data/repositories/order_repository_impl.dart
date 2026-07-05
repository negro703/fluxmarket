import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_local_datasource.dart';

/// Implementation of [OrderRepository] that uses [OrderLocalDataSource]
/// for local data persistence.
@LazySingleton(as: OrderRepository)
class OrderRepositoryImpl implements OrderRepository {
  final OrderLocalDataSource _localDataSource;

  OrderRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, OrderEntity>> placeOrder(OrderEntity order) async {
    try {
      await _localDataSource.saveOrder(order);
      return Right(order);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrders() async {
    try {
      final models = await _localDataSource.getAllOrders();
      // Orders are stored without items details, return empty list for items
      final orders = models.map((model) {
        // Note: We don't have original cart items, so create a summary order
        return model.toEntity([]);
      }).toList();
      return Right(orders);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearOrders() async {
    try {
      await _localDataSource.clearAllOrders();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
