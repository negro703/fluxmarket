import 'package:equatable/equatable.dart';

/// Events that can be dispatched to the [AuthBloc].
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event triggered when a user attempts to log in.
class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Event triggered when a user attempts to register.
class RegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final String fullName;

  const RegisterEvent({
    required this.email,
    required this.password,
    required this.fullName,
  });

  @override
  List<Object?> get props => [email, password, fullName];
}

/// Event triggered when the app checks if the user is already authenticated.
class CheckAuthStatusEvent extends AuthEvent {
  const CheckAuthStatusEvent();
}

/// Event triggered when a user logs out.
class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}