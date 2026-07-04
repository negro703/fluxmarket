import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

/// Local data source for caching authentication data.
///
/// Stores the auth token and user profile locally using [SharedPreferences].
@LazySingleton()
class AuthLocalDataSource {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user';

  final SharedPreferences _prefs;

  AuthLocalDataSource(this._prefs);

  /// Caches the authentication [token] locally.
  Future<void> cacheToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  /// Retrieves the cached authentication token.
  ///
  /// Returns `null` if no token is stored.
  String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  /// Caches the [user] profile locally.
  Future<void> cacheUser(UserModel user) async {
    final jsonString = jsonEncode(user.toJson());
    await _prefs.setString(_userKey, jsonString);
  }

  /// Retrieves the cached user profile.
  ///
  /// Throws a [CacheException] if the cached data is corrupted.
  UserModel? getCachedUser() {
    final jsonString = _prefs.getString(_userKey);
    if (jsonString == null) return null;

    try {
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserModel.fromJson(jsonMap);
    } catch (e) {
      throw const CacheException(message: 'Failed to parse cached user data');
    }
  }

  /// Clears all cached authentication data (token + user).
  Future<void> clearAuthData() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_userKey);
  }

  /// Returns `true` if a valid auth token is stored locally.
  bool hasToken() {
    final token = _prefs.getString(_tokenKey);
    return token != null && token.isNotEmpty;
  }
}