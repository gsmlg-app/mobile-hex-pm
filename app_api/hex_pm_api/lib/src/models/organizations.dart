// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'organizations.g.dart';

@JsonSerializable()
class Organizations {
  const Organizations({
    required this.name,
    required this.role,
  });
  
  factory Organizations.fromJson(Map<String, Object?> json) => _$OrganizationsFromJson(json);
  
  /// Name of the organization.
  final String name;

  /// User's role in the organization.
  final String role;

  Map<String, Object?> toJson() => _$OrganizationsToJson(this);
}
