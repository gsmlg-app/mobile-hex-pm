// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'api_key_permission.dart';

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
  final List<ApiKeyPermission> permissions;
  @JsonKey(name: 'revoked_at')
  final DateTime? revokedAt;
  @JsonKey(name: 'inserted_at')
  final DateTime insertedAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final String url;
  final String secret;

  Map<String, Object?> toJson() => _$ApiKeyWithSecretToJson(this);
}
