// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/release.dart';
import '../models/retirement_payload.dart';

part 'package_releases_client.g.dart';

@RestApi()
abstract class PackageReleasesClient {
  factory PackageReleasesClient(Dio dio, {String? baseUrl}) =
      _PackageReleasesClient;

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

  /// Publish a Release.
  ///
  /// Publishes a new release version of a package. This will also create the package if it does not exist. The request body must be a package tarball.
  @POST('/publish')
  Future<Release> publishRelease({
    @Body() required File body,
  });

  /// Mark Release as Retired.
  ///
  /// [name] - The package name.
  ///
  /// [version] - The release version.
  @POST('/packages/{name}/releases/{version}/retire')
  Future<void> retireRelease({
    @Body() required RetirementPayload body,
    @Path('name') required String name,
    @Path('version') required String version,
  });

  /// Unmark Release as Retired.
  ///
  /// [name] - The package name.
  ///
  /// [version] - The release version.
  @DELETE('/packages/{name}/releases/{version}/retire')
  Future<void> unretireRelease({
    @Path('name') required String name,
    @Path('version') required String version,
  });
}
