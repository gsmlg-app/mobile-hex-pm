// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'documentation_client.g.dart';

@RestApi()
abstract class DocumentationClient {
  factory DocumentationClient(Dio dio, {String? baseUrl}) = _DocumentationClient;

  /// Publish Package Documentation
  @POST('/packages/{name}/releases/{version}/docs')
  Future<void> publishDocs({
    @Path('name') required String name,
    @Path('version') required String version,
    @Body() required File body,
  });

  /// Remove Package Documentation
  @DELETE('/packages/{name}/releases/{version}/docs')
  Future<void> deleteDocs({
    @Path('name') required String name,
    @Path('version') required String version,
  });
}
