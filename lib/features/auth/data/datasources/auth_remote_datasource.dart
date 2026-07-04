import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

/// Remote data source for authentication API calls.
///
/// Handles all HTTP communication with the authentication backend.
@LazySingleton()
class AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSource(this._dio);

  /// Authenticates a user with [email] and [password].
  ///
  /// Throws a [ServerException] on failure.
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final userData = data['user'] as Map<String, dynamic>? ?? data;
        return UserModel.fromJson(userData);
      } else {
        throw ServerException(
          message: response.data?['message'] as String? ?? 'Login failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Creates a new user account.
  ///
  /// Throws a [ServerException] on failure.
  Future<UserModel> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
          'fullName': fullName,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;
        final userData = data['user'] as Map<String, dynamic>? ?? data;
        return UserModel.fromJson(userData);
      } else {
        throw ServerException(
          message: response.data?['message'] as String? ?? 'Registration failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Logs out the current user by invalidating the session on the server.
  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Fetches the currently authenticated user's profile.
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _dio.get('/auth/me');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final userData = data['user'] as Map<String, dynamic>? ?? data;
        return UserModel.fromJson(userData);
      } else {
        throw ServerException(
          message: response.data?['message'] as String? ?? 'Failed to get user',
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
          message: message ?? 'Server error occurred',
          statusCode: statusCode,
        );
      case DioExceptionType.cancel:
        return const ServerException(
          message: 'Request was cancelled',
          statusCode: 499,
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