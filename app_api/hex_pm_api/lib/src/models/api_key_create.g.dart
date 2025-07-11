// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_key_create.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiKeyCreate _$ApiKeyCreateFromJson(Map<String, dynamic> json) => ApiKeyCreate(
      name: json['name'] as String,
      permissions: (json['permissions'] as List<dynamic>?)
          ?.map((e) => Permissions2.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ApiKeyCreateToJson(ApiKeyCreate instance) =>
    <String, dynamic>{
      'name': instance.name,
      'permissions': instance.permissions,
    };
