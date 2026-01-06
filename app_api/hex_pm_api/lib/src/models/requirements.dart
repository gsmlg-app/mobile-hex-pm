// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'requirements.g.dart';

@JsonSerializable()
class Requirements {
  const Requirements({
    this.name,
    this.requirement,
    this.optional,
    this.app,
  });

  factory Requirements.fromJson(Map<String, Object?> json) =>
      _$RequirementsFromJson(json);

  final String? name;
  final String? requirement;
  final bool? optional;
  final String? app;

  Map<String, Object?> toJson() => _$RequirementsToJson(this);
}
