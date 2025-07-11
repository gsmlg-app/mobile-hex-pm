// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'permissions2.dart';

part 'api_key_create.g.dart';

@JsonSerializable()
class ApiKeyCreate {
  const ApiKeyCreate({
    required this.name,
    this.permissions,
  });
  
  factory ApiKeyCreate.fromJson(Map<String, Object?> json) => _$ApiKeyCreateFromJson(json);
  
  final String name;
  final List<Permissions2>? permissions;

  Map<String, Object?> toJson() => _$ApiKeyCreateToJson(this);
}
