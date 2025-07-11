// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum Reason {
  @JsonValue('other')
  other('other'),
  @JsonValue('invalid')
  invalid('invalid'),
  @JsonValue('security')
  security('security'),
  @JsonValue('deprecated')
  deprecated('deprecated'),
  @JsonValue('renamed')
  renamed('renamed'),
  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const Reason(this.json);

  factory Reason.fromJson(String json) => values.firstWhere(
        (e) => e.json == json,
        orElse: () => $unknown,
      );

  final String? json;

  @override
  String toString() => json ?? super.toString();
  /// Returns all defined enum values excluding the $unknown value.
  static List<Reason> get $valuesDefined => values.where((value) => value != $unknown).toList();
}
