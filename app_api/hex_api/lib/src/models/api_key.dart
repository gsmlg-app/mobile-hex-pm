// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'api_key_permission.dart';

part 'api_key.g.dart';

@JsonSerializable()
class ApiKey {
  const ApiKey({
    required this.name,
    required this.permissions,
    required this.insertedAt,
    required this.updatedAt,
    required this.url,
    this.revokedAt,
  });
  
  factory ApiKey.fromJson(Map<String, Object?> json) => _$ApiKeyFromJson(json);
  
  final String name;
  final List<ApiKeyPermission> permissions;
  @JsonKey(name: 'revoked_at')
  final DateTime? revokedAt;
  @JsonKey(name: 'inserted_at')
  final DateTime insertedAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final String url;

  Map<String, Object?> toJson() => _$ApiKeyToJson(this);
}
