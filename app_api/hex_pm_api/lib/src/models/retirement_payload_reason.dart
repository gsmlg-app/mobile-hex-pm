// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

/// Reason for retiring the release.
@JsonEnum()
enum RetirementPayloadReason {
  @JsonValue('other')
  other,
  @JsonValue('invalid')
  invalid,
  @JsonValue('security')
  security,
  @JsonValue('deprecated')
  deprecated,
  @JsonValue('renamed')
  renamed;
}
