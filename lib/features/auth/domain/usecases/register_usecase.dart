import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Input parameters for the [RegisterUseCase].
class RegisterParams {
  final String email;
  final String password;
  final String fullName;

  const RegisterParams({
    required this.email,
    required this.password,
    required this.fullName,
  });
}

/// Use case for creating a new user account.
///
/// Follows the Clean Architecture use case pattern, depending on the
/// [AuthRepository] abstraction rather than a concrete implementation.
@LazySingleton()
class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  /// Executes the register use case.
  ///
  /// Returns a [UserEntity] on success or a [Failure] on error.
  Future<Either<Failure, UserEntity>> call(RegisterParams params) {
    return _repository.register(
      email: params.email,
      password: params.password,
      fullName: params.fullName,
    );
  }
}
