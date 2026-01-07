// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'release.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Release _$ReleaseFromJson(Map<String, dynamic> json) => Release(
      version: json['version'] as String,
      hasDocs: json['has_docs'] as bool,
      meta: ReleaseMeta.fromJson(json['meta'] as Map<String, dynamic>),
      downloads: (json['downloads'] as num).toInt(),
      insertedAt: DateTime.parse(json['inserted_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      url: json['url'] as String,
      packageUrl: json['package_url'] as String,
      requirements: (json['requirements'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, ReleaseRequirement.fromJson(e as Map<String, dynamic>)),
      ),
      retired: json['retired'] == null
          ? null
          : ReleaseRetired.fromJson(json['retired'] as Map<String, dynamic>),
      htmlUrl: json['html_url'] as String?,
      docsHtmlUrl: json['docs_html_url'] as String?,
    );

Map<String, dynamic> _$ReleaseToJson(Release instance) => <String, dynamic>{
      'version': instance.version,
      'has_docs': instance.hasDocs,
      'meta': instance.meta,
      'requirements': instance.requirements,
      'retired': instance.retired,
      'downloads': instance.downloads,
      'inserted_at': instance.insertedAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'url': instance.url,
      'package_url': instance.packageUrl,
      'html_url': instance.htmlUrl,
      'docs_html_url': instance.docsHtmlUrl,
    };
