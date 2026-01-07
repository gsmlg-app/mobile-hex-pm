// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'release_meta.dart';
import 'release_requirement.dart';
import 'release_retired.dart';

part 'release.g.dart';

@JsonSerializable()
class Release {
  const Release({
    required this.version,
    required this.hasDocs,
    required this.meta,
    required this.downloads,
    required this.insertedAt,
    required this.updatedAt,
    required this.url,
    required this.packageUrl,
    this.requirements,
    this.retired,
    this.htmlUrl,
    this.docsHtmlUrl,
  });

  factory Release.fromJson(Map<String, Object?> json) =>
      _$ReleaseFromJson(json);

  final String version;
  @JsonKey(name: 'has_docs')
  final bool hasDocs;
  final ReleaseMeta meta;
  final Map<String, ReleaseRequirement>? requirements;
  final ReleaseRetired? retired;
  final int downloads;
  @JsonKey(name: 'inserted_at')
  final DateTime insertedAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final String url;
  @JsonKey(name: 'package_url')
  final String packageUrl;
  @JsonKey(name: 'html_url')
  final String? htmlUrl;
  @JsonKey(name: 'docs_html_url')
  final String? docsHtmlUrl;

  Map<String, Object?> toJson() => _$ReleaseToJson(this);
}
