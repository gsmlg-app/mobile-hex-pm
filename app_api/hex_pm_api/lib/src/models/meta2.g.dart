// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta2.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meta2 _$Meta2FromJson(Map<String, dynamic> json) => Meta2(
      buildTools: (json['build_tools'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$Meta2ToJson(Meta2 instance) => <String, dynamic>{
      'build_tools': instance.buildTools,
    };
