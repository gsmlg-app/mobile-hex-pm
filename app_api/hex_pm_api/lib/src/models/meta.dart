// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'meta.g.dart';

@JsonSerializable()
class Meta {
  const Meta({
    this.description,
    this.licenses,
    this.links,
  });
  
  factory Meta.fromJson(Map<String, Object?> json) => _$MetaFromJson(json);
  
  final String? description;
  final List<String>? licenses;
  final Map<String, String>? links;

  Map<String, Object?> toJson() => _$MetaToJson(this);
}
