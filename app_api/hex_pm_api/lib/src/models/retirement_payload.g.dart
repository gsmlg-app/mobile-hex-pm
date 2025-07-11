// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'retirement_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RetirementPayload _$RetirementPayloadFromJson(Map<String, dynamic> json) =>
    RetirementPayload(
      reason: RetirementPayloadReason.fromJson(json['reason'] as String),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$RetirementPayloadToJson(RetirementPayload instance) =>
    <String, dynamic>{
      'reason': _$RetirementPayloadReasonEnumMap[instance.reason]!,
      'message': instance.message,
    };

const _$RetirementPayloadReasonEnumMap = {
  RetirementPayloadReason.other: 'other',
  RetirementPayloadReason.invalid: 'invalid',
  RetirementPayloadReason.security: 'security',
  RetirementPayloadReason.deprecated: 'deprecated',
  RetirementPayloadReason.renamed: 'renamed',
  RetirementPayloadReason.$unknown: r'$unknown',
};
