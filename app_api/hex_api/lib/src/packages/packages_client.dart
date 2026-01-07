// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/package.dart';
import '../models/sort.dart';

part 'packages_client.g.dart';

@RestApi()
abstract class PackagesClient {
  factory PackagesClient(Dio dio, {String? baseUrl}) = _PackagesClient;

  /// List all Packages.
  ///
  /// [sort] - Field to sort by.
  ///
  /// [search] - Search string.
  ///
  /// [page] - Page number for pagination.
  @GET('/packages')
  Future<List<Package>> listPackages({
    @Query('search') String? search,
    @Query('sort') Sort? sort = Sort.name,
    @Query('page') int? page = 1,
  });

  /// Fetch a Package.
  ///
  /// [name] - The name of the package.
  @GET('/packages/{name}')
  Future<Package> getPackage({
    @Path('name') required String name,
  });
}
