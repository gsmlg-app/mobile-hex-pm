// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'retirement_payload_reason.dart';

part 'retirement_payload.g.dart';

@JsonSerializable()
class RetirementPayload {
  const RetirementPayload({
    required this.reason,
    this.message,
  });
  
  factory RetirementPayload.fromJson(Map<String, Object?> json) => _$RetirementPayloadFromJson(json);
  
  /// Reason for retiring the release.
  final RetirementPayloadReason reason;

  /// An additional, clarifying message for the retirement.
  final String? message;

  Map<String, Object?> toJson() => _$RetirementPayloadToJson(this);
}
