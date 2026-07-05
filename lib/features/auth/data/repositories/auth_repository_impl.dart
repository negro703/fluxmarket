import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

/// Implementation of [AuthRepository] that coordinates between remote and
/// local data sources.
///
/// Follows the repository pattern: remote data source is the source of truth,
/// local data source acts as a cache for offline access.
@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await _remoteDataSource.login(
        email: email,
        password: password,
      );
      // Cache the user data locally
      await _localDataSource.cacheUser(userModel);
      return Right(userModel);
    } on Exception catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final userModel = await _remoteDataSource.register(
        email: email,
        password: password,
        fullName: fullName,
      );
      // Cache the user data locally
      await _localDataSource.cacheUser(userModel);
      return Right(userModel);
    } on Exception catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _remoteDataSource.logout();
      await _localDataSource.clearAuthData();
      return const Right(null);
    } on Exception catch (e) {
      // Even if remote logout fails, clear local data
      await _localDataSource.clearAuthData();
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      // Try remote first
      final userModel = await _remoteDataSource.getCurrentUser();
      // Only cache if user exists
      if (userModel != null) {
        await _localDataSource.cacheUser(userModel);
      }
      return Right(userModel);
    } on Exception {
      // Fall back to cached user
      try {
        final cachedUser = _localDataSource.getCachedUser();
        return Right(cachedUser);
      } on Exception catch (e) {
        return Left(_mapExceptionToFailure(e));
      }
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    return _localDataSource.hasToken();
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
