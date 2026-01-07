// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'user_create.g.dart';

@JsonSerializable()
class UserCreate {
  const UserCreate({
    required this.username,
    required this.password,
    required this.email,
  });
  
  factory UserCreate.fromJson(Map<String, Object?> json) => _$UserCreateFromJson(json);
  
  final String username;
  final String password;
  final String email;

  Map<String, Object?> toJson() => _$UserCreateToJson(this);
}
