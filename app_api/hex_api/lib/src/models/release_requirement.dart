// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'release_requirement.g.dart';

@JsonSerializable()
class ReleaseRequirement {
  const ReleaseRequirement({
    this.name,
    this.requirement,
    this.optional,
    this.app,
  });

  factory ReleaseRequirement.fromJson(Map<String, Object?> json) =>
      _$ReleaseRequirementFromJson(json);

  final String? name;
  final String? requirement;
  final bool? optional;
  final String? app;

  Map<String, Object?> toJson() => _$ReleaseRequirementToJson(this);
}
