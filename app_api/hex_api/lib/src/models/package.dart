// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'package_downloads.dart';
import 'package_meta.dart';
import 'package_release.dart';

part 'package.g.dart';

@JsonSerializable()
class Package {
  const Package({
    required this.name,
    required this.meta,
    required this.downloads,
    required this.releases,
    required this.insertedAt,
    required this.updatedAt,
    required this.url,
    this.repository,
    this.private,
    this.htmlUrl,
    this.docsHtmlUrl,
  });
  
  factory Package.fromJson(Map<String, Object?> json) => _$PackageFromJson(json);
  
  final String name;
  final String? repository;
  final bool? private;
  final PackageMeta meta;
  final PackageDownloads downloads;
  final List<PackageRelease> releases;
  @JsonKey(name: 'inserted_at')
  final DateTime insertedAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final String url;
  @JsonKey(name: 'html_url')
  final String? htmlUrl;
  @JsonKey(name: 'docs_html_url')
  final String? docsHtmlUrl;

  Map<String, Object?> toJson() => _$PackageToJson(this);
}
