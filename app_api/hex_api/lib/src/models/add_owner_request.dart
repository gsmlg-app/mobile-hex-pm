// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'add_owner_request_level.dart';

part 'add_owner_request.g.dart';

@JsonSerializable()
class AddOwnerRequest {
  const AddOwnerRequest({
    this.level = AddOwnerRequestLevel.maintainer,
  });
  
  factory AddOwnerRequest.fromJson(Map<String, Object?> json) => _$AddOwnerRequestFromJson(json);
  
  final AddOwnerRequestLevel level;

  Map<String, Object?> toJson() => _$AddOwnerRequestToJson(this);
}
