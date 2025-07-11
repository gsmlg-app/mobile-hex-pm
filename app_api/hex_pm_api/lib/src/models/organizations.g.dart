// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organizations.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Organizations _$OrganizationsFromJson(Map<String, dynamic> json) =>
    Organizations(
      name: json['name'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$OrganizationsToJson(Organizations instance) =>
    <String, dynamic>{
      'name': instance.name,
      'role': instance.role,
    };
