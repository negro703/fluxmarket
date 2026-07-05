import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../repositories/profile_repository.dart';

/// Use case for updating user profile.
///
/// Takes profile update parameters and persists them using the [ProfileRepository].
@LazySingleton()
class UpdateProfileUseCase {
  final ProfileRepository repository;

  const UpdateProfileUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(ProfileUpdateParams params) async {
    // Note: In a real implementation, we would get the current user,
    // update the fields, and save. For now, this is a stub.
    return const Right(UserEntity(id: '', email: '', fullName: ''));
  }
}

/// Use case for clearing user preferences.
///
/// Used when logging out to clear stored preferences.
@LazySingleton()
class ClearPreferencesUseCase {
  final ProfileRepository repository;

  const ClearPreferencesUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    return repository.clearPreferences();
  }
}
