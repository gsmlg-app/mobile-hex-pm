// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'user_create.g.dart';

@JsonSerializable()
class UserCreate {
  const UserCreate({
    required this.username,
    required this.password,
    required this.email,
  });

  factory UserCreate.fromJson(Map<String, Object?> json) =>
      _$UserCreateFromJson(json);

  /// Alphanumeric characters, underscores, hyphens, and dots. Case insensitive.
  final String username;

  /// A printable UTF-8 string.
  final String password;
  final String email;

  Map<String, Object?> toJson() => _$UserCreateToJson(this);
}
