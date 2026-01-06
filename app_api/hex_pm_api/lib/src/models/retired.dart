// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'reason.dart';

part 'retired.g.dart';

@JsonSerializable()
class Retired {
  const Retired({
    this.reason,
    this.message,
  });

  factory Retired.fromJson(Map<String, Object?> json) =>
      _$RetiredFromJson(json);

  final Reason? reason;
  final String? message;

  Map<String, Object?> toJson() => _$RetiredToJson(this);
}
