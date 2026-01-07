// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/user.dart';
import '../models/user_create.dart';
import '../models/user_with_orgs.dart';

part 'users_client.g.dart';

@RestApi()
abstract class UsersClient {
  factory UsersClient(Dio dio, {String? baseUrl}) = _UsersClient;

  /// Create a User
  @POST('/users')
  Future<User> createUser({
    @Body() required UserCreate body,
  });

  /// Fetch a User.
  ///
  /// [username] - The username.
  @GET('/users/{username}')
  Future<User> getUser({
    @Path('username') required String username,
  });

  /// Fetch Currently Authenticated User
  @GET('/users/me')
  Future<UserWithOrgs> getCurrentUser();
}
