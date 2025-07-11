// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'organizations.dart';

part 'user_with_orgs.g.dart';

@JsonSerializable()
class UserWithOrgs {
  const UserWithOrgs({
    required this.username,
    required this.email,
    required this.insertedAt,
    required this.updatedAt,
    required this.url,
    required this.organizations,
  });
  
  factory UserWithOrgs.fromJson(Map<String, Object?> json) => _$UserWithOrgsFromJson(json);
  
  /// User's unique username.
  final String username;

  /// User's primary email address.
  final String email;
  @JsonKey(name: 'inserted_at')
  final DateTime insertedAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final String url;
  final List<Organizations> organizations;

  Map<String, Object?> toJson() => _$UserWithOrgsToJson(this);
}
