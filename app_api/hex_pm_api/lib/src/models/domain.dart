// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum Domain {
  @JsonValue('api')
  api('api'),
  @JsonValue('repository')
  repository('repository'),
  @JsonValue('repositories')
  repositories('repositories'),
  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const Domain(this.json);

  factory Domain.fromJson(String json) => values.firstWhere(
        (e) => e.json == json,
        orElse: () => $unknown,
      );

  final String? json;

  @override
  String toString() => json ?? super.toString();
  /// Returns all defined enum values excluding the $unknown value.
  static List<Domain> get $valuesDefined => values.where((value) => value != $unknown).toList();
}
