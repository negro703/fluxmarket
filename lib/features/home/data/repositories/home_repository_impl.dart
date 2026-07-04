import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';

/// Implementation of [HomeRepository] that fetches data from the remote API.
@LazySingleton(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;

  HomeRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    try {
      final products = await _remoteDataSource.getProducts();
      return Right(products);
    } on Exception catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductById(int id) async {
    try {
      final product = await _remoteDataSource.getProductById(id);
      return Right(product);
    } on Exception catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  /// Maps an [Exception] to the appropriate [Failure] type.
  Failure _mapExceptionToFailure(Exception e) {
    final message = e.toString();
    if (message.contains('timeout') || message.contains('Timeout')) {
      return const ServerFailure(
        message: 'Connection timed out. Please try again.',
        statusCode: 408,
      );
    }
    if (message.contains('internet') ||
        message.contains('connection') ||
        message.contains('Connection')) {
      return const NetworkFailure();
    }
    return ServerFailure(message: message);
  }
}