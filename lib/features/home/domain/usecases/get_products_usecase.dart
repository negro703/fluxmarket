import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/product_entity.dart';
import '../repositories/home_repository.dart';

/// Use case for fetching a list of products.
///
/// Follows the Clean Architecture use case pattern, depending on the
/// [HomeRepository] abstraction rather than a concrete implementation.
@LazySingleton()
class GetProductsUseCase {
  final HomeRepository _repository;

  GetProductsUseCase(this._repository);

  /// Executes the get products use case.
  ///
  /// Returns a list of [ProductEntity] on success or a [Failure] on error.
  Future<Either<Failure, List<ProductEntity>>> call() {
    return _repository.getProducts();
  }
}