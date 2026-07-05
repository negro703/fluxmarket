import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Base class for profile events.
sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

/// Event to toggle theme between light and dark mode.
class ToggleThemeEvent extends ProfileEvent {
  final ThemeMode currentTheme;

  const ToggleThemeEvent(this.currentTheme);

  @override
  List<Object> get props => [currentTheme];
}

/// Event to load user profile data.
class LoadProfileEvent extends ProfileEvent {
  const LoadProfileEvent();
}

/// Event to update user profile.
class UpdateProfileEvent extends ProfileEvent {
  final String fullName;
  final String email;

  const UpdateProfileEvent({required this.fullName, required this.email});

  @override
  List<Object> get props => [fullName, email];
}
