import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../auth/domain/entities/user_entity.dart';

/// Base class for profile states.
sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

/// Initial state when profile is first loaded.
class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

/// Loading state when profile data is being fetched.
class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

/// Loaded state when profile data is available.
class ProfileLoaded extends ProfileState {
  final UserEntity? user;
  final ThemeMode themeMode;

  const ProfileLoaded({required this.user, this.themeMode = ThemeMode.light});

  @override
  List<Object?> get props => [user, themeMode];
}

/// Error state when profile operation fails.
class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message});

  @override
  List<Object> get props => [message];
}

/// Success state when profile update completes.
class ProfileUpdateSuccess extends ProfileState {
  final UserEntity user;

  const ProfileUpdateSuccess({required this.user});

  @override
  List<Object> get props => [user];
}
