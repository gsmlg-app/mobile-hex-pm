// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'repository.g.dart';

@JsonSerializable()
class Repository {
  const Repository({
    required this.name,
    required this.public,
    required this.active,
    required this.billingActive,
    required this.insertedAt,
    required this.updatedAt,
  });

  factory Repository.fromJson(Map<String, Object?> json) =>
      _$RepositoryFromJson(json);

  final String name;
  final bool public;
  final bool active;
  @JsonKey(name: 'billing_active')
  final bool billingActive;
  @JsonKey(name: 'inserted_at')
  final DateTime insertedAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  Map<String, Object?> toJson() => _$RepositoryToJson(this);
}
