import 'package:flutter/foundation.dart';

import '../../domain/entities/user_entity.dart';

/// Data layer model for a user, with JSON serialization/deserialization.
///
/// Extends [UserEntity] so it can be used wherever the entity is expected,
/// maintaining Clean Architecture dependency rules (data depends on domain).
@immutable
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.fullName,
    super.phoneNumber,
    super.avatarUrl,
    super.createdAt,
  });

  /// Creates a [UserModel] from a JSON map (e.g., API response).
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String? ?? json['full_name'] as String,
      phoneNumber:
          json['phoneNumber'] as String? ?? json['phone_number'] as String?,
      avatarUrl: json['avatarUrl'] as String? ?? json['avatar_url'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  /// Converts this model to a JSON map for API requests.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  /// Converts to a JSON map with snake_case keys (common for REST APIs).
  Map<String, dynamic> toSnakeCaseJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'avatar_url': avatarUrl,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  /// Creates a [UserModel] from a [UserEntity].
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      fullName: entity.fullName,
      phoneNumber: entity.phoneNumber,
      avatarUrl: entity.avatarUrl,
      createdAt: entity.createdAt,
    );
  }
}
