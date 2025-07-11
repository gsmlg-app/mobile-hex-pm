// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'domain.dart';

part 'permissions2.g.dart';

@JsonSerializable()
class Permissions2 {
  const Permissions2({
    this.domain,
    this.resource,
  });
  
  factory Permissions2.fromJson(Map<String, Object?> json) => _$Permissions2FromJson(json);
  
  final Domain? domain;
  final String? resource;

  Map<String, Object?> toJson() => _$Permissions2ToJson(this);
}
