// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Package _$PackageFromJson(Map<String, dynamic> json) => Package(
      name: json['name'] as String,
      meta: PackageMeta.fromJson(json['meta'] as Map<String, dynamic>),
      downloads:
          PackageDownloads.fromJson(json['downloads'] as Map<String, dynamic>),
      releases: (json['releases'] as List<dynamic>)
          .map((e) => PackageRelease.fromJson(e as Map<String, dynamic>))
          .toList(),
      insertedAt: DateTime.parse(json['inserted_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      url: json['url'] as String,
      repository: json['repository'] as String?,
      private: json['private'] as bool?,
      htmlUrl: json['html_url'] as String?,
      docsHtmlUrl: json['docs_html_url'] as String?,
    );

Map<String, dynamic> _$PackageToJson(Package instance) => <String, dynamic>{
      'name': instance.name,
      'repository': instance.repository,
      'private': instance.private,
      'meta': instance.meta,
      'downloads': instance.downloads,
      'releases': instance.releases,
      'inserted_at': instance.insertedAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'url': instance.url,
      'html_url': instance.htmlUrl,
      'docs_html_url': instance.docsHtmlUrl,
    };
