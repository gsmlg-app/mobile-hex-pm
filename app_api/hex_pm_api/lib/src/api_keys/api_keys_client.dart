// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/api_key.dart';
import '../models/api_key_create.dart';
import '../models/api_key_with_secret.dart';

part 'api_keys_client.g.dart';

@RestApi()
abstract class ApiKeysClient {
  factory ApiKeysClient(Dio dio, {String? baseUrl}) = _ApiKeysClient;

  /// List all API Keys
  @GET('/keys')
  Future<List<ApiKey>> listKeys();

  /// Create an API Key.
  ///
  /// Creates a new API key. This endpoint requires Basic Authentication.  The key's secret is only returned on creation and must be stored securely.
  @POST('/keys')
  Future<ApiKeyWithSecret> createKey({
    @Body() required ApiKeyCreate body,
  });

  /// Fetch an API Key.
  ///
  /// [name] - The name of the API key.
  @GET('/keys/{name}')
  Future<ApiKey> getKey({
    @Path('name') required String name,
  });

  /// Remove an API Key.
  ///
  /// [name] - The name of the API key.
  @DELETE('/keys/{name}')
  Future<void> removeKey({
    @Path('name') required String name,
  });
}
