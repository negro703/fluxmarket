import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Input parameters for the [LoginUseCase].
class LoginParams {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });
}

/// Use case for authenticating a user with email and password.
///
/// Follows the Clean Architecture use case pattern, depending on the
/// [AuthRepository] abstraction rather than a concrete implementation.
@LazySingleton()
class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  /// Executes the login use case.
  ///
  /// Returns a [UserEntity] on success or a [Failure] on error.
  Future<Either<Failure, UserEntity>> call(LoginParams params) {
    return _repository.login(
      email: params.email,
      password: params.password,
    );
  }
}