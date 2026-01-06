// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'downloads.g.dart';

@JsonSerializable()
class Downloads {
  const Downloads({
    this.all,
    this.week,
    this.day,
  });

  factory Downloads.fromJson(Map<String, Object?> json) =>
      _$DownloadsFromJson(json);

  final int? all;
  final int? week;
  final int? day;

  Map<String, Object?> toJson() => _$DownloadsToJson(this);
}
