// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'api_key_permission_domain.dart';

part 'api_key_permission.g.dart';

@JsonSerializable()
class ApiKeyPermission {
  const ApiKeyPermission({
    this.domain,
    this.resource,
  });

  factory ApiKeyPermission.fromJson(Map<String, Object?> json) =>
      _$ApiKeyPermissionFromJson(json);

  final ApiKeyPermissionDomain? domain;
  final String? resource;

  Map<String, Object?> toJson() => _$ApiKeyPermissionToJson(this);
}
