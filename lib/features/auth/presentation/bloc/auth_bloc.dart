import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// BLoC that manages authentication state for the application.
///
/// Handles [LoginEvent], [RegisterEvent], [LogoutEvent], and
/// [CheckAuthStatusEvent] to manage the user's authentication lifecycle.
@LazySingleton()
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final AuthRepository _authRepository;

  AuthBloc(
    this._loginUseCase,
    this._registerUseCase,
    this._authRepository,
  ) : super(const AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  /// Handles the [LoginEvent] by calling the [LoginUseCase].
  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final result = await _loginUseCase(
      LoginParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  /// Handles the [RegisterEvent] by calling the [RegisterUseCase].
  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final result = await _registerUseCase(
      RegisterParams(
        email: event.email,
        password: event.password,
        fullName: event.fullName,
      ),
    );

    result.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  /// Handles the [LogoutEvent] by calling the repository's logout method.
  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final result = await _authRepository.logout();

    result.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (_) => emit(const AuthInitial()),
    );
  }

  /// Handles the [CheckAuthStatusEvent] by checking if the user is
  /// already authenticated and has a cached profile.
  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    final isAuthenticated = await _authRepository.isAuthenticated();

    if (isAuthenticated) {
      final result = await _authRepository.getCurrentUser();

      result.fold(
        (failure) => emit(const AuthInitial()),
        (user) {
          if (user != null) {
            emit(AuthSuccess(user: user));
          } else {
            emit(const AuthInitial());
          }
        },
      );
    } else {
      emit(const AuthInitial());
    }
  }
}