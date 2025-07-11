// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/repository.dart';

part 'repositories_client.g.dart';

@RestApi()
abstract class RepositoriesClient {
  factory RepositoriesClient(Dio dio, {String? baseUrl}) = _RepositoriesClient;

  /// List all Repositories.
  ///
  /// Returns all public repositories and, if authenticated, all repositories the user is a member of.
  @GET('/repos')
  Future<List<Repository>> listRepos();

  /// Fetch a Repository
  @GET('/repos/{name}')
  Future<Repository> getRepo({
    @Path('name') required String name,
  });
}
