// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';

import 'users/users_client.dart';
import 'repositories/repositories_client.dart';
import 'packages/packages_client.dart';
import 'releases/releases_client.dart';
import 'documentation/documentation_client.dart';
import 'owners/owners_client.dart';
import 'api_keys/api_keys_client.dart';

/// Hex API `v1.0.0`.
///
/// API for hex.pm package registry.
class HexApi {
  HexApi(
    Dio dio, {
    String? baseUrl,
  })  : _dio = dio,
        _baseUrl = baseUrl;

  final Dio _dio;
  final String? _baseUrl;

  static String get version => '1.0.0';

  UsersClient? _users;
  RepositoriesClient? _repositories;
  PackagesClient? _packages;
  ReleasesClient? _releases;
  DocumentationClient? _documentation;
  OwnersClient? _owners;
  ApiKeysClient? _apiKeys;

  UsersClient get users => _users ??= UsersClient(_dio, baseUrl: _baseUrl);

  RepositoriesClient get repositories => _repositories ??= RepositoriesClient(_dio, baseUrl: _baseUrl);

  PackagesClient get packages => _packages ??= PackagesClient(_dio, baseUrl: _baseUrl);

  ReleasesClient get releases => _releases ??= ReleasesClient(_dio, baseUrl: _baseUrl);

  DocumentationClient get documentation => _documentation ??= DocumentationClient(_dio, baseUrl: _baseUrl);

  OwnersClient get owners => _owners ??= OwnersClient(_dio, baseUrl: _baseUrl);

  ApiKeysClient get apiKeys => _apiKeys ??= ApiKeysClient(_dio, baseUrl: _baseUrl);
}
