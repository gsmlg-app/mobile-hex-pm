// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/release.dart';
import '../models/retirement_payload.dart';

part 'releases_client.g.dart';

@RestApi()
abstract class ReleasesClient {
  factory ReleasesClient(Dio dio, {String? baseUrl}) = _ReleasesClient;

  /// Fetch a Release.
  ///
  /// [name] - The name of the package.
  ///
  /// [version] - The release version.
  @GET('/packages/{name}/releases/{version}')
  Future<Release> getRelease({
    @Path('name') required String name,
    @Path('version') required String version,
  });

  /// Publish a Release
  @POST('/publish')
  Future<Release> publishRelease({
    @Body() required File body,
  });

  /// Mark Release as Retired
  @POST('/packages/{name}/releases/{version}/retire')
  Future<void> retireRelease({
    @Path('name') required String name,
    @Path('version') required String version,
    @Body() required RetirementPayload body,
  });

  /// Unmark Release as Retired
  @DELETE('/packages/{name}/releases/{version}/retire')
  Future<void> unretireRelease({
    @Path('name') required String name,
    @Path('version') required String version,
  });
}
