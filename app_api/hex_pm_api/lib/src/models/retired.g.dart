// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'retired.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Retired _$RetiredFromJson(Map<String, dynamic> json) => Retired(
      reason: $enumDecodeNullable(_$ReasonEnumMap, json['reason']),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$RetiredToJson(Retired instance) => <String, dynamic>{
      'reason': _$ReasonEnumMap[instance.reason],
      'message': instance.message,
    };

const _$ReasonEnumMap = {
  Reason.other: 'other',
  Reason.invalid: 'invalid',
  Reason.security: 'security',
  Reason.deprecated: 'deprecated',
  Reason.renamed: 'renamed',
};
