// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'meta2.g.dart';

@JsonSerializable()
class Meta2 {
  const Meta2({
    this.buildTools,
  });

  factory Meta2.fromJson(Map<String, Object?> json) => _$Meta2FromJson(json);

  @JsonKey(name: 'build_tools')
  final List<String>? buildTools;

  Map<String, Object?> toJson() => _$Meta2ToJson(this);
}
