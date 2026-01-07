// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackageMeta _$PackageMetaFromJson(Map<String, dynamic> json) => PackageMeta(
      description: json['description'] as String?,
      licenses: (json['licenses'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      links: (json['links'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$PackageMetaToJson(PackageMeta instance) =>
    <String, dynamic>{
      'description': instance.description,
      'licenses': instance.licenses,
      'links': instance.links,
    };
