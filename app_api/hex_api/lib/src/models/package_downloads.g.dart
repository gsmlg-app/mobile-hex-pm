// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_downloads.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackageDownloads _$PackageDownloadsFromJson(Map<String, dynamic> json) =>
    PackageDownloads(
      all: (json['all'] as num?)?.toInt(),
      week: (json['week'] as num?)?.toInt(),
      day: (json['day'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PackageDownloadsToJson(PackageDownloads instance) =>
    <String, dynamic>{
      'all': instance.all,
      'week': instance.week,
      'day': instance.day,
    };
