// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'release_retired_reason.dart';

part 'release_retired.g.dart';

@JsonSerializable()
class ReleaseRetired {
  const ReleaseRetired({
    this.reason,
    this.message,
  });
  
  factory ReleaseRetired.fromJson(Map<String, Object?> json) => _$ReleaseRetiredFromJson(json);
  
  final ReleaseRetiredReason? reason;
  final String? message;

  Map<String, Object?> toJson() => _$ReleaseRetiredToJson(this);
}
