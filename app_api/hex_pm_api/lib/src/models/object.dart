// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'level.dart';

part 'object.g.dart';

@JsonSerializable()
class Object {
  const Object({
    this.level = Level.maintainer,
  });

  factory Object.fromJson(Map<String, String> json) => _$ObjectFromJson(json);

  final Level level;

  Map<String, String?> toJson() => _$ObjectToJson(this);
}
