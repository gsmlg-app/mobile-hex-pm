// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'requirements.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Requirements _$RequirementsFromJson(Map<String, dynamic> json) => Requirements(
      name: json['name'] as String?,
      requirement: json['requirement'] as String?,
      optional: json['optional'] as bool?,
      app: json['app'] as String?,
    );

Map<String, dynamic> _$RequirementsToJson(Requirements instance) =>
    <String, dynamic>{
      'name': instance.name,
      'requirement': instance.requirement,
      'optional': instance.optional,
      'app': instance.app,
    };
