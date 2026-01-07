// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  const User({
    required this.username,
    required this.email,
    required this.insertedAt,
    required this.updatedAt,
    required this.url,
  });
  
  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
  
  final String username;
  final String email;
  @JsonKey(name: 'inserted_at')
  final DateTime insertedAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final String url;

  Map<String, Object?> toJson() => _$UserToJson(this);
}
