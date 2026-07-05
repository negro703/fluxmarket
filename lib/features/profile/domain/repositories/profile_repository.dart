import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../auth/domain/entities/user_entity.dart';

/// Abstract repository for profile operations.
///
/// This is the contract that the data layer must implement.
abstract class ProfileRepository {
  /// Updates the user profile.
  Future<Either<Failure, UserEntity>> updateProfile(UserEntity user);

  /// Clears user preferences (e.g., theme settings).
  Future<Either<Failure, void>> clearPreferences();
}

/// Parameters for profile updates.
class ProfileUpdateParams extends Equatable {
  final String? fullName;
  final String? email;

  const ProfileUpdateParams({this.fullName, this.email});

  @override
  List<Object?> get props => [fullName, email];
}
