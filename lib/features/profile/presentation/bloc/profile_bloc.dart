import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

/// BLoC that manages profile state and settings.
///
/// Handles [ToggleThemeEvent] and [UpdateProfileEvent] for managing
/// user preferences and profile updates.
@LazySingleton()
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ThemeMode _currentTheme = ThemeMode.light;
  final AuthRepository _authRepository;

  ProfileBloc(this._authRepository) : super(const ProfileInitial()) {
    on<ToggleThemeEvent>(_onToggleTheme);
    on<LoadProfileEvent>(_onLoadProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
  }

  ThemeMode get currentTheme => _currentTheme;

  Future<void> _onToggleTheme(
    ToggleThemeEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      _currentTheme = event.currentTheme == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
      final user = await _getCurrentUser();
      emit(ProfileLoaded(user: user, themeMode: _currentTheme));
    } catch (e) {
      emit(ProfileError(message: 'Failed to toggle theme: ${e.toString()}'));
    }
  }

  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    try {
      final user = await _getCurrentUser();
      emit(ProfileLoaded(user: user, themeMode: _currentTheme));
    } catch (e) {
      emit(ProfileError(message: 'Failed to load profile: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    try {
      final currentUser = await _getCurrentUser();
      if (currentUser != null) {
        final updatedUser = currentUser.copyWith(
          fullName: event.fullName,
          email: event.email,
        );
        emit(ProfileUpdateSuccess(user: updatedUser));
      } else {
        emit(const ProfileError(message: 'No user to update'));
      }
    } catch (e) {
      emit(ProfileError(message: 'Failed to update profile: ${e.toString()}'));
    }
  }

  /// Gets the current authenticated user from AuthRepository.
  Future<UserEntity?> _getCurrentUser() async {
    final result = await _authRepository.getCurrentUser();
    return result.fold((failure) => null, (user) => user);
  }
}
