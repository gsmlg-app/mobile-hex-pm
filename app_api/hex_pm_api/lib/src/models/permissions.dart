// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'domain.dart';

part 'permissions.g.dart';

@JsonSerializable()
class Permissions {
  const Permissions({
    this.domain,
    this.resource,
  });

  factory Permissions.fromJson(Map<String, Object?> json) =>
      _$PermissionsFromJson(json);

  final Domain? domain;
  final String? resource;

  Map<String, Object?> toJson() => _$PermissionsToJson(this);
}
