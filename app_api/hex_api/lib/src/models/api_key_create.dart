// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'api_key_permission.dart';

part 'api_key_create.g.dart';

@JsonSerializable()
class ApiKeyCreate {
  const ApiKeyCreate({
    required this.name,
    this.permissions,
  });
  
  factory ApiKeyCreate.fromJson(Map<String, Object?> json) => _$ApiKeyCreateFromJson(json);
  
  final String name;
  final List<ApiKeyPermission>? permissions;

  Map<String, Object?> toJson() => _$ApiKeyCreateToJson(this);
}
