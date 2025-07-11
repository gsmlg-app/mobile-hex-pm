// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meta _$MetaFromJson(Map<String, dynamic> json) => Meta(
      description: json['description'] as String?,
      licenses: (json['licenses'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      links: (json['links'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
      'description': instance.description,
      'licenses': instance.licenses,
      'links': instance.links,
    };
