// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

/// Ownership level. 'full' owners can manage other owners.
@JsonEnum()
enum OwnerLevel {
  @JsonValue('full')
  full,
  @JsonValue('maintainer')
  maintainer;
}
