// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'owner_level.dart';

part 'owner.g.dart';

@JsonSerializable()
class Owner {
  const Owner({
    required this.username,
    required this.email,
    required this.insertedAt,
    required this.updatedAt,
    required this.url,
    required this.level,
  });
  
  factory Owner.fromJson(Map<String, Object?> json) => _$OwnerFromJson(json);
  
  /// User's unique username.
  final String username;

  /// User's primary email address.
  final String email;
  @JsonKey(name: 'inserted_at')
  final DateTime insertedAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final String url;

  /// Ownership level. 'full' owners can manage other owners.
  final OwnerLevel level;

  Map<String, Object?> toJson() => _$OwnerToJson(this);
}
