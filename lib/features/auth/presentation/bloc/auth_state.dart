import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entity.dart';

/// Possible states for the [AuthBloc].
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any authentication event has been processed.
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// State emitted while an authentication operation is in progress.
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// State emitted when authentication succeeds.
class AuthSuccess extends AuthState {
  final UserEntity user;

  const AuthSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

/// State emitted when authentication fails.
class AuthFailure extends AuthState {
  final String message;

  const AuthFailure({required this.message});

  @override
  List<Object?> get props => [message];
}