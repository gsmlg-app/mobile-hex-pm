// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'release_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReleaseMeta _$ReleaseMetaFromJson(Map<String, dynamic> json) => ReleaseMeta(
      buildTools: (json['build_tools'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ReleaseMetaToJson(ReleaseMeta instance) =>
    <String, dynamic>{
      'build_tools': instance.buildTools,
    };
