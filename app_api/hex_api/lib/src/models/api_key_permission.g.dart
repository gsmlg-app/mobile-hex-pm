// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_key_permission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiKeyPermission _$ApiKeyPermissionFromJson(Map<String, dynamic> json) =>
    ApiKeyPermission(
      domain:
          $enumDecodeNullable(_$ApiKeyPermissionDomainEnumMap, json['domain']),
      resource: json['resource'] as String?,
    );

Map<String, dynamic> _$ApiKeyPermissionToJson(ApiKeyPermission instance) =>
    <String, dynamic>{
      'domain': _$ApiKeyPermissionDomainEnumMap[instance.domain],
      'resource': instance.resource,
    };

const _$ApiKeyPermissionDomainEnumMap = {
  ApiKeyPermissionDomain.api: 'api',
  ApiKeyPermissionDomain.repository: 'repository',
  ApiKeyPermissionDomain.repositories: 'repositories',
};
