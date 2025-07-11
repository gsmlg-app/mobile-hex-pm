// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'downloads.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Downloads _$DownloadsFromJson(Map<String, dynamic> json) => Downloads(
      all: (json['all'] as num?)?.toInt(),
      week: (json['week'] as num?)?.toInt(),
      day: (json['day'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DownloadsToJson(Downloads instance) => <String, dynamic>{
      'all': instance.all,
      'week': instance.week,
      'day': instance.day,
    };
