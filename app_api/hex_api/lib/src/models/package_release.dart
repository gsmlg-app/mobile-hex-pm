// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'package_release.g.dart';

@JsonSerializable()
class PackageRelease {
  const PackageRelease({
    this.version,
    this.url,
  });

  factory PackageRelease.fromJson(Map<String, Object?> json) =>
      _$PackageReleaseFromJson(json);

  final String? version;
  final String? url;

  Map<String, Object?> toJson() => _$PackageReleaseToJson(this);
}
