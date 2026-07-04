import 'package:equatable/equatable.dart';

/// Represents a user in the FluxMarket application.
class UserEntity extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String? phoneNumber;
  final String? avatarUrl;
  final DateTime? createdAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.fullName,
    this.phoneNumber,
    this.avatarUrl,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, email, fullName, phoneNumber, avatarUrl, createdAt];
}