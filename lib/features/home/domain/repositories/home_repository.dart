import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/product_entity.dart';

/// Abstract repository for home/product operations.
///
/// This is the contract that the domain layer defines and the data layer
/// implements, following Clean Architecture's dependency inversion principle.
abstract class HomeRepository {
  /// Fetches a list of all products from the remote API.
  ///
  /// Returns a list of [ProductEntity] on success or a [Failure] on error.
  Future<Either<Failure, List<ProductEntity>>> getProducts();

  /// Fetches a single product by its [id].
  ///
  /// Returns a [ProductEntity] on success or a [Failure] on error.
  Future<Either<Failure, ProductEntity>> getProductById(int id);
}
