// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_owner_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddOwnerRequest _$AddOwnerRequestFromJson(Map<String, dynamic> json) =>
    AddOwnerRequest(
      level:
          $enumDecodeNullable(_$AddOwnerRequestLevelEnumMap, json['level']) ??
              AddOwnerRequestLevel.maintainer,
    );

Map<String, dynamic> _$AddOwnerRequestToJson(AddOwnerRequest instance) =>
    <String, dynamic>{
      'level': _$AddOwnerRequestLevelEnumMap[instance.level]!,
    };

const _$AddOwnerRequestLevelEnumMap = {
  AddOwnerRequestLevel.full: 'full',
  AddOwnerRequestLevel.maintainer: 'maintainer',
};
