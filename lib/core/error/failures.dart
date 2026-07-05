/// Abstract base class for all application-level failures.
/// Uses [Equatable] for value comparison in BLoC state management.
abstract class Failure {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Failure &&
        other.message == message &&
        other.statusCode == statusCode;
  }

  @override
  int get hashCode => message.hashCode ^ statusCode.hashCode;
}

/// Failure returned when a server/API error occurs.
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.statusCode});

  factory ServerFailure.fromDioError({
    required String message,
    int? statusCode,
  }) {
    return ServerFailure(message: message, statusCode: statusCode);
  }
}

/// Failure returned when a local cache/storage error occurs.
class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.statusCode});
}

/// Failure returned when there is no network connection.
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection',
    super.statusCode,
  });
}

/// Failure returned for unexpected/unknown errors.
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'An unexpected error occurred',
    super.statusCode,
  });
}
