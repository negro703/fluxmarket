import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

/// Abstract repository for authentication operations.
///
/// This is the contract that the domain layer defines and the data layer
/// implements, following Clean Architecture's dependency inversion principle.
abstract class AuthRepository {
  /// Authenticates a user with [email] and [password].
  ///
  /// Returns a [UserEntity] on success or a [Failure] on error.
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });

  /// Creates a new user account with the given credentials.
  ///
  /// Returns a [UserEntity] on success or a [Failure] on error.
  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String password,
    required String fullName,
  });

  /// Logs out the currently authenticated user.
  ///
  /// Returns `void` on success or a [Failure] on error.
  Future<Either<Failure, void>> logout();

  /// Returns the currently cached/authenticated user, if any.
  Future<Either<Failure, UserEntity?>> getCurrentUser();

  /// Returns `true` if the user has a valid authentication token stored.
  Future<bool> isAuthenticated();
}
