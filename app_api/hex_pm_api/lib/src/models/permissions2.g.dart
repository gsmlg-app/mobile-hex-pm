// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permissions2.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Permissions2 _$Permissions2FromJson(Map<String, dynamic> json) => Permissions2(
      domain: $enumDecodeNullable(_$DomainEnumMap, json['domain']),
      resource: json['resource'] as String?,
    );

Map<String, dynamic> _$Permissions2ToJson(Permissions2 instance) =>
    <String, dynamic>{
      'domain': _$DomainEnumMap[instance.domain],
      'resource': instance.resource,
    };

const _$DomainEnumMap = {
  Domain.api: 'api',
  Domain.repository: 'repository',
  Domain.repositories: 'repositories',
};
