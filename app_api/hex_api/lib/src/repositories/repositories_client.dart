// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/repository.dart';

part 'repositories_client.g.dart';

@RestApi()
abstract class RepositoriesClient {
  factory RepositoriesClient(Dio dio, {String? baseUrl}) = _RepositoriesClient;

  /// List all Repositories
  @GET('/repos')
  Future<List<Repository>> listRepos();

  /// Fetch a Repository
  @GET('/repos/{name}')
  Future<Repository> getRepo({
    @Path('name') required String name,
  });
}
