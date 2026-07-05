import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../models/product_model.dart';

/// Remote data source for fetching product data from the FakeStore API.
@LazySingleton()
class HomeRemoteDataSource {
  final Dio _dio;

  HomeRemoteDataSource(this._dio);

  /// Fetches all products from the FakeStore API.
  ///
  /// Throws a [ServerException] on failure.
  Future<List<ProductModel>> getProducts() async {
    try {
      // Override the base URL for FakeStore API calls
      final response = await _dio.get('https://fakestoreapi.com/products');

      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        return data
            .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(
          message: 'Failed to fetch products',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Fetches a single product by its [id].
  ///
  /// Throws a [ServerException] on failure.
  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await _dio.get('https://fakestoreapi.com/products/$id');

      if (response.statusCode == 200) {
        return ProductModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ServerException(
          message: 'Failed to fetch product',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Handles [DioException] and converts it to a [ServerException].
  ServerException _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ServerException(
          message: 'Connection timed out. Please try again.',
          statusCode: 408,
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data is Map<String, dynamic>
            ? (e.response!.data as Map<String, dynamic>)['message'] as String?
            : null;
        return ServerException(
          message: message ?? 'Failed to load products',
          statusCode: statusCode,
        );
      case DioExceptionType.connectionError:
        return const ServerException(
          message: 'No internet connection',
          statusCode: 503,
        );
      default:
        return const ServerException(
          message: 'An unexpected error occurred',
          statusCode: 500,
        );
    }
  }
}
