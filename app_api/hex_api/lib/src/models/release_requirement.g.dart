// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'release_requirement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReleaseRequirement _$ReleaseRequirementFromJson(Map<String, dynamic> json) =>
    ReleaseRequirement(
      name: json['name'] as String?,
      requirement: json['requirement'] as String?,
      optional: json['optional'] as bool?,
      app: json['app'] as String?,
    );

Map<String, dynamic> _$ReleaseRequirementToJson(ReleaseRequirement instance) =>
    <String, dynamic>{
      'name': instance.name,
      'requirement': instance.requirement,
      'optional': instance.optional,
      'app': instance.app,
    };
