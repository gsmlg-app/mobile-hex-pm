// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'package_documentation_client.g.dart';

@RestApi()
abstract class PackageDocumentationClient {
  factory PackageDocumentationClient(Dio dio, {String? baseUrl}) = _PackageDocumentationClient;

  /// Publish Package Documentation.
  ///
  /// Upload documentation for a specific package release. The body must be a gzipped tarball containing the documentation files, including an `index.html`.
  ///
  /// [name] - The package name.
  ///
  /// [version] - The release version.
  @POST('/packages/{name}/releases/{version}/docs')
  Future<void> publishDocs({
    @Body() required File body,
    @Path('name') required String name,
    @Path('version') required String version,
  });

  /// Remove Package Documentation.
  ///
  /// [name] - The package name.
  ///
  /// [version] - The release version.
  @DELETE('/packages/{name}/releases/{version}/docs')
  Future<void> deleteDocs({
    @Path('name') required String name,
    @Path('version') required String version,
  });
}
