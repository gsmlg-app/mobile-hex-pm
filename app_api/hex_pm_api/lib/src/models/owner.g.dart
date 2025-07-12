// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Owner _$OwnerFromJson(Map<String, dynamic> json) => Owner(
      username: json['username'] as String,
      email: json['email'] as String,
      insertedAt: DateTime.parse(json['inserted_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      url: json['url'] as String,
      level: $enumDecode(_$OwnerLevelEnumMap, json['level']),
    );

Map<String, dynamic> _$OwnerToJson(Owner instance) => <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'inserted_at': instance.insertedAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'url': instance.url,
      'level': _$OwnerLevelEnumMap[instance.level]!,
    };

const _$OwnerLevelEnumMap = {
  OwnerLevel.full: 'full',
  OwnerLevel.maintainer: 'maintainer',
};
