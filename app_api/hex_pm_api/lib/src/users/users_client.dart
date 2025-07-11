// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/user.dart';
import '../models/user_create.dart';
import '../models/user_with_orgs.dart';

part 'users_client.g.dart';

@RestApi()
abstract class UsersClient {
  factory UsersClient(Dio dio, {String? baseUrl}) = _UsersClient;

  /// Create a User.
  ///
  /// Creates a new user. A confirmation email with an activation link is sent to the provided email address.  The account must be activated before it can be used.  Clients must display a link to the Hex Terms of Service.
  @POST('/users')
  Future<User> createUser({
    @Body() required UserCreate body,
  });

  /// Fetch a User.
  ///
  /// [usernameOrEmail] - The username or primary email address of the user.
  @GET('/users/{username_or_email}')
  Future<User> getUser({
    @Path('username_or_email') required String usernameOrEmail,
  });

  /// Fetch Currently Authenticated User
  @GET('/users/me')
  Future<UserWithOrgs> getCurrentUser();

  /// Reset User Password.
  ///
  /// Initiates the password reset process. An email with a reset link will be sent to the user's primary email address.
  ///
  /// [usernameOrEmail] - The username or email address of the user.
  @POST('/users/{username_or_email}/reset')
  Future<void> resetUserPassword({
    @Path('username_or_email') required String usernameOrEmail,
  });
}
