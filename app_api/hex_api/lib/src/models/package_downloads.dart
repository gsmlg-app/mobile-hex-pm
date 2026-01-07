// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'package_downloads.g.dart';

@JsonSerializable()
class PackageDownloads {
  const PackageDownloads({
    this.all,
    this.week,
    this.day,
  });

  factory PackageDownloads.fromJson(Map<String, Object?> json) =>
      _$PackageDownloadsFromJson(json);

  final int? all;
  final int? week;
  final int? day;

  Map<String, Object?> toJson() => _$PackageDownloadsToJson(this);
}
