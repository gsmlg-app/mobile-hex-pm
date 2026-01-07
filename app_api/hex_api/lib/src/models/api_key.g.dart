// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_key.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiKey _$ApiKeyFromJson(Map<String, dynamic> json) => ApiKey(
      name: json['name'] as String,
      permissions: (json['permissions'] as List<dynamic>)
          .map((e) => ApiKeyPermission.fromJson(e as Map<String, dynamic>))
          .toList(),
      insertedAt: DateTime.parse(json['inserted_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      url: json['url'] as String,
      revokedAt: json['revoked_at'] == null
          ? null
          : DateTime.parse(json['revoked_at'] as String),
    );

Map<String, dynamic> _$ApiKeyToJson(ApiKey instance) => <String, dynamic>{
      'name': instance.name,
      'permissions': instance.permissions,
      'revoked_at': instance.revokedAt?.toIso8601String(),
      'inserted_at': instance.insertedAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'url': instance.url,
    };
