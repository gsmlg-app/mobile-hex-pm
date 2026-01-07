// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'release_retired.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReleaseRetired _$ReleaseRetiredFromJson(Map<String, dynamic> json) =>
    ReleaseRetired(
      reason:
          $enumDecodeNullable(_$ReleaseRetiredReasonEnumMap, json['reason']),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$ReleaseRetiredToJson(ReleaseRetired instance) =>
    <String, dynamic>{
      'reason': _$ReleaseRetiredReasonEnumMap[instance.reason],
      'message': instance.message,
    };

const _$ReleaseRetiredReasonEnumMap = {
  ReleaseRetiredReason.other: 'other',
  ReleaseRetiredReason.invalid: 'invalid',
  ReleaseRetiredReason.security: 'security',
  ReleaseRetiredReason.deprecated: 'deprecated',
  ReleaseRetiredReason.renamed: 'renamed',
};
