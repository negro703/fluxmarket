import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_datasource.dart';

/// Implementation of [CartRepository] that uses [CartLocalDataSource]
/// for persistent cart storage via Hive.
@LazySingleton(as: CartRepository)
class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource _localDataSource;

  CartRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, List<CartItemEntity>>> addToCart({
    required CartItemEntity item,
  }) async {
    try {
      final currentItems = _localDataSource.getCartItems();
      final existingIndex = currentItems.indexWhere(
        (i) => i.product.id == item.product.id,
      );

      if (existingIndex >= 0) {
        // Product exists — increment quantity
        final existing = currentItems[existingIndex];
        currentItems[existingIndex] = existing.copyWith(
          quantity: existing.quantity + item.quantity,
        );
      } else {
        // New product — add to list
        currentItems.add(item);
      }

      await _localDataSource.saveCartItems(currentItems);
      return Right(currentItems);
    } on Exception catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<CartItemEntity>>> removeFromCart({
    required int productId,
  }) async {
    try {
      final currentItems = _localDataSource.getCartItems();
      currentItems.removeWhere((item) => item.product.id == productId);
      await _localDataSource.saveCartItems(currentItems);
      return Right(currentItems);
    } on Exception catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

@override
  Future<Either<Failure, List<CartItemEntity>>> decrementQuantity({
    required int productId,
  }) async {
    try {
      final currentItems = _localDataSource.getCartItems();
      final existingIndex = currentItems.indexWhere(
        (item) => item.product.id == productId,
      );

      if (existingIndex >= 0) {
        final existing = currentItems[existingIndex];
        if (existing.quantity <= 1) {
          // Remove if quantity would reach 0
          currentItems.removeAt(existingIndex);
        } else {
          currentItems[existingIndex] = existing.copyWith(
            quantity: existing.quantity - 1,
          );
        }
      }

      await _localDataSource.saveCartItems(currentItems);
      return Right(currentItems);
    } on Exception catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<CartItemEntity>>> updateQuantity({
    required int productId,
    required int newQuantity,
  }) async {
    try {
      final currentItems = _localDataSource.getCartItems();
      final existingIndex = currentItems.indexWhere(
        (item) => item.product.id == productId,
      );

      if (existingIndex >= 0) {
        if (newQuantity <= 0) {
          // Remove if quantity would reach 0 or less
          currentItems.removeAt(existingIndex);
        } else {
          currentItems[existingIndex] = currentItems[existingIndex].copyWith(
            quantity: newQuantity,
          );
        }
      }

      await _localDataSource.saveCartItems(currentItems);
      return Right(currentItems);
    } on Exception catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<CartItemEntity>>> getCartItems() async {
    try {
      final items = _localDataSource.getCartItems();
      return Right(items);
    } on Exception catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> clearCart() async {
    try {
      await _localDataSource.clearCart();
      return const Right(null);
    } on Exception catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<int> getItemCount() async {
    try {
      final items = _localDataSource.getCartItems();
      int total = 0;
      for (final item in items) {
        total += item.quantity;
      }
      return total;
    } on Exception {
      return 0;
    }
  }

  /// Maps an [Exception] to the appropriate [Failure] type.
  Failure _mapExceptionToFailure(Exception e) {
    final message = e.toString();
    if (message.contains('timeout') || message.contains('Timeout')) {
      return const ServerFailure(
        message: 'Operation timed out.',
        statusCode: 408,
      );
    }
    return CacheFailure(message: message);
  }
}