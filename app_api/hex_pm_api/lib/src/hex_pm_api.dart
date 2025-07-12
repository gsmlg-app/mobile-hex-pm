// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';

import 'users/users_client.dart';
import 'repositories/repositories_client.dart';
import 'packages/packages_client.dart';
import 'package_releases/package_releases_client.dart';
import 'package_documentation/package_documentation_client.dart';
import 'package_owners/package_owners_client.dart';
import 'api_keys/api_keys_client.dart';

/// Hex API `v1.0.0`.
///
/// This is the complete OpenAPI specification for the Hex API, based on the provided API Blueprint documentation. The Hex API is a REST-based API currently in beta.  The implementation examples are from https://hex.pm/api. .
///
/// ### Media Types.
/// The API supports JSON and a safe subset of Erlang terms for requests and responses. Clients should specify their desired format in the `Accept` header. .
/// - `application/json`.
/// - `application/vnd.hex+json`.
/// - `application/vnd.hex+erlang`.
///
/// ### Rate Limiting.
/// The API limits requests to 100 per minute per IP, or 500 per minute for authenticated users.  Conditional requests resulting in a `304 Not Modified` do not count towards the limit.  The following headers are returned with each request to indicate the current status: .
/// - `X-RateLimit-Limit`: Maximum requests per minute. .
/// - `X-RateLimit-Remaining`: Remaining requests in the current window. .
/// - `X-RateLimit-Reset`: UNIX timestamp for when the limit resets. .
///
/// ### User-Agent.
/// All requests MUST include a valid `User-Agent` header, or they will be rejected with a `400 Bad Request`.  Example: `User-Agent: Hex/0.12.1 (Elixir/1.3.0) (OTP/19.0)`. .
///
/// ### Pagination.
/// Collection resources are paginated, returning up to 100 items per page.  The `page` query parameter can be used to navigate through pages, which are 1-indexed. .
///
/// ### Authentication.
/// Authentication is performed via Basic Authentication (for generating API tokens) or an API token.  Failed authentication returns `401 Unauthorized`.
///
class HexPmApi {
  HexPmApi(
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
  PackageReleasesClient? _packageReleases;
  PackageDocumentationClient? _packageDocumentation;
  PackageOwnersClient? _packageOwners;
  ApiKeysClient? _apiKeys;

  UsersClient get users => _users ??= UsersClient(_dio, baseUrl: _baseUrl);

  RepositoriesClient get repositories => _repositories ??= RepositoriesClient(_dio, baseUrl: _baseUrl);

  PackagesClient get packages => _packages ??= PackagesClient(_dio, baseUrl: _baseUrl);

  PackageReleasesClient get packageReleases => _packageReleases ??= PackageReleasesClient(_dio, baseUrl: _baseUrl);

  PackageDocumentationClient get packageDocumentation => _packageDocumentation ??= PackageDocumentationClient(_dio, baseUrl: _baseUrl);

  PackageOwnersClient get packageOwners => _packageOwners ??= PackageOwnersClient(_dio, baseUrl: _baseUrl);

  ApiKeysClient get apiKeys => _apiKeys ??= ApiKeysClient(_dio, baseUrl: _baseUrl);
}
