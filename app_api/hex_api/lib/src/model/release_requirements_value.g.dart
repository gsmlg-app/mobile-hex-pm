// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'release_requirements_value.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReleaseRequirementsValue _$ReleaseRequirementsValueFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'ReleaseRequirementsValue',
      json,
      ($checkedConvert) {
        final val = ReleaseRequirementsValue(
          name: $checkedConvert('name', (v) => v as String?),
          requirement: $checkedConvert('requirement', (v) => v as String?),
          optional: $checkedConvert('optional', (v) => v as bool?),
          app: $checkedConvert('app', (v) => v as String?),
        );
        return val;
      },
    );

Map<String, dynamic> _$ReleaseRequirementsValueToJson(
        ReleaseRequirementsValue instance) =>
    <String, dynamic>{
      if (instance.name case final value?) 'name': value,
      if (instance.requirement case final value?) 'requirement': value,
      if (instance.optional case final value?) 'optional': value,
      if (instance.app case final value?) 'app': value,
    };
