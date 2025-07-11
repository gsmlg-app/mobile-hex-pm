// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Object _$ObjectFromJson(Map<String, dynamic> json) => Object(
      level: json['level'] == null
          ? Level.maintainer
          : Level.fromJson(json['level'] as String),
    );

Map<String, String> _$ObjectToJson(Object instance) => <String, String>{
      'level': _$LevelEnumMap[instance.level]!,
    };

const _$LevelEnumMap = {
  Level.full: 'full',
  Level.maintainer: 'maintainer',
  Level.$unknown: r'$unknown',
};
