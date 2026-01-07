// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'release_meta.g.dart';

@JsonSerializable()
class ReleaseMeta {
  const ReleaseMeta({
    this.buildTools,
  });
  
  factory ReleaseMeta.fromJson(Map<String, Object?> json) => _$ReleaseMetaFromJson(json);
  
  @JsonKey(name: 'build_tools')
  final List<String>? buildTools;

  Map<String, Object?> toJson() => _$ReleaseMetaToJson(this);
}
