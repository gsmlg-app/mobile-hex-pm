// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_with_orgs.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserWithOrgs _$UserWithOrgsFromJson(Map<String, dynamic> json) => UserWithOrgs(
      username: json['username'] as String,
      email: json['email'] as String,
      insertedAt: DateTime.parse(json['inserted_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      url: json['url'] as String,
      organizations: (json['organizations'] as List<dynamic>)
          .map((e) => Organizations.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserWithOrgsToJson(UserWithOrgs instance) =>
    <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'inserted_at': instance.insertedAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'url': instance.url,
      'organizations': instance.organizations,
    };
