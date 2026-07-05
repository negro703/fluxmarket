import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../domain/repositories/profile_repository.dart';

/// Implementation of profile repository that handles user profile operations.
@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  @override
  Future<Either<Failure, UserEntity>> updateProfile(UserEntity user) async {
    // TODO: Implement actual profile update logic
    // For now, return the user as-is (mock implementation)
    return Right(user);
  }

  @override
  Future<Either<Failure, void>> clearPreferences() async {
    // TODO: Implement actual preferences clearing logic
    return const Right(null);
  }
}
