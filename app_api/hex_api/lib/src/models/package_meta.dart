// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'package_meta.g.dart';

@JsonSerializable()
class PackageMeta {
  const PackageMeta({
    this.description,
    this.licenses,
    this.links,
  });

  factory PackageMeta.fromJson(Map<String, Object?> json) =>
      _$PackageMetaFromJson(json);

  final String? description;
  final List<String>? licenses;
  final Map<String, String>? links;

  Map<String, Object?> toJson() => _$PackageMetaToJson(this);
}
