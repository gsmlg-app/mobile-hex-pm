// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permissions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Permissions _$PermissionsFromJson(Map<String, dynamic> json) => Permissions(
      domain: $enumDecodeNullable(_$DomainEnumMap, json['domain']),
      resource: json['resource'] as String?,
    );

Map<String, dynamic> _$PermissionsToJson(Permissions instance) =>
    <String, dynamic>{
      'domain': _$DomainEnumMap[instance.domain],
      'resource': instance.resource,
    };

const _$DomainEnumMap = {
  Domain.api: 'api',
  Domain.repository: 'repository',
  Domain.repositories: 'repositories',
};
