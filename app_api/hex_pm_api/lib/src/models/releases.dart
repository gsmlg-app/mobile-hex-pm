// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'releases.g.dart';

@JsonSerializable()
class Releases {
  const Releases({
    this.version,
    this.url,
  });

  factory Releases.fromJson(Map<String, Object?> json) =>
      _$ReleasesFromJson(json);

  final String? version;
  final String? url;

  Map<String, Object?> toJson() => _$ReleasesToJson(this);
}
