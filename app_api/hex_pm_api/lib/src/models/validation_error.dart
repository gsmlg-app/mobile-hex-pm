// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'validation_error.g.dart';

@JsonSerializable()
class ValidationError {
  const ValidationError({
    this.status,
    this.message,
    this.errors,
  });
  
  factory ValidationError.fromJson(Map<String, Object?> json) => _$ValidationErrorFromJson(json);
  
  final int? status;
  final String? message;
  final Map<String, String>? errors;

  Map<String, Object?> toJson() => _$ValidationErrorToJson(this);
}
