/// Abstract base class for all application-level exceptions.
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException({required this.message, this.statusCode});

  @override
  String toString() => 'AppException: $message (statusCode: $statusCode)';
}

/// Exception thrown when a server/API request fails.
class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.statusCode,
  });

  /// Creates a [ServerException] from a Dio error response.
  factory ServerException.fromDioError({
    required String message,
    int? statusCode,
    dynamic responseData,
  }) {
    final parsedMessage = responseData is Map<String, dynamic>
        ? (responseData['message'] as String? ?? message)
        : message;
    return ServerException(message: parsedMessage, statusCode: statusCode);
  }
}

/// Exception thrown when a local cache/storage operation fails.
class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.statusCode,
  });
}

/// Exception thrown when there is no network connectivity.
class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No internet connection',
    super.statusCode,
  });
}