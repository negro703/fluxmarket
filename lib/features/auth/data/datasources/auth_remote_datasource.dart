import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

/// Remote data source for Firebase Authentication.
///
/// Handles all Firebase Auth operations: sign-in, sign-up, sign-out, and user management.
@LazySingleton()
class AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;

  AuthRemoteDataSource(this._firebaseAuth);

  /// Authenticates a user with [email] and [password].
  ///
  /// Throws a [ServerException] on failure.
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw const ServerException(message: 'Authentication failed');
      }

      return UserModel(
        id: user.uid,
        email: user.email ?? '',
        fullName: user.displayName ?? 'User',
      );
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  /// Creates a new user account with [email], [password], and [fullName].
  ///
  /// Throws a [ServerException] on failure.
  Future<UserModel> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw const ServerException(message: 'Registration failed');
      }

      // Update display name
      await user.updateDisplayName(fullName);

      return UserModel(
        id: user.uid,
        email: user.email ?? '',
        fullName: fullName,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  /// Logs out the current user.
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  /// Fetches the currently authenticated user's profile.
  ///
  /// Returns `null` if no user is signed in.
  Future<UserModel?> getCurrentUser() async {
    // currentUser is synchronous and never throws FirebaseAuthException
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      return null;
    }

    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      fullName: user.displayName ?? 'User',
    );
  }

  /// Handles [FirebaseAuthException] and converts it to a [ServerException].
  ServerException _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return const ServerException(
          message: 'No account found with this email address',
          statusCode: 404,
        );
      case 'wrong-password':
        return const ServerException(
          message: 'Incorrect password. Please try again.',
          statusCode: 401,
        );
      case 'email-already-in-use':
        return const ServerException(
          message: 'This email is already registered. Please sign in.',
          statusCode: 409,
        );
      case 'weak-password':
        return const ServerException(
          message: 'Password is too weak. Please use at least 6 characters.',
          statusCode: 400,
        );
      case 'invalid-email':
        return const ServerException(
          message: 'Invalid email address format.',
          statusCode: 400,
        );
      case 'user-disabled':
        return const ServerException(
          message: 'This account has been disabled.',
          statusCode: 403,
        );
      case 'network-request-failed':
        return const ServerException(
          message: 'No internet connection. Please check your network.',
          statusCode: 503,
        );
      default:
        return ServerException(
          message: e.message ?? 'An unexpected authentication error occurred',
          statusCode: 500,
        );
    }
  }
}
