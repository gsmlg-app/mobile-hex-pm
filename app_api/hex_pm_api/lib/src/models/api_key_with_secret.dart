// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'permissions.dart';

part 'api_key_with_secret.g.dart';

@JsonSerializable()
class ApiKeyWithSecret {
  const ApiKeyWithSecret({
    required this.name,
    required this.permissions,
    required this.insertedAt,
    required this.updatedAt,
    required this.url,
    required this.secret,
    this.revokedAt,
  });

  factory ApiKeyWithSecret.fromJson(Map<String, Object?> json) =>
      _$ApiKeyWithSecretFromJson(json);

  final String name;
  final List<Permissions> permissions;
  @JsonKey(name: 'revoked_at')
  final DateTime? revokedAt;
  @JsonKey(name: 'inserted_at')
  final DateTime insertedAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final String url;

  /// The key secret, a 32 character hex encoded string. Only returned on creation.
  final String secret;

  Map<String, Object?> toJson() => _$ApiKeyWithSecretToJson(this);
}
