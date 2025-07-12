// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Object _$ObjectFromJson(Map<String, dynamic> json) => Object(
      level: $enumDecodeNullable(_$LevelEnumMap, json['level']) ??
          Level.maintainer,
    );

Map<String, Object> _$ObjectToJson(Object instance) => <String, Object>{
      'level': _$LevelEnumMap[instance.level]!,
    };

const _$LevelEnumMap = {
  Level.full: 'full',
  Level.maintainer: 'maintainer',
};
