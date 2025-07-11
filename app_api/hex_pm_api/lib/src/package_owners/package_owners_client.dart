// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/object.dart';
import '../models/owner.dart';

part 'package_owners_client.g.dart';

@RestApi()
abstract class PackageOwnersClient {
  factory PackageOwnersClient(Dio dio, {String? baseUrl}) = _PackageOwnersClient;

  /// Fetch Package Owners.
  ///
  /// [name] - The package name.
  @GET('/packages/{name}/owners')
  Future<List<Owner>> getOwners({
    @Path('name') required String name,
  });

  /// Add a Package Owner.
  ///
  /// [body] - Name not received and was auto-generated.
  ///
  /// [name] - The package name.
  ///
  /// [email] - The email address of the user to add as an owner.
  @PUT('/packages/{name}/owners/{email}')
  Future<void> addOwner({
    @Path('name') required String name,
    @Path('email') required String email,
    @Body() dynamic body,
  });

  /// Remove a Package Owner.
  ///
  /// [name] - The package name.
  ///
  /// [email] - The email address of the user to add as an owner.
  @DELETE('/packages/{name}/owners/{email}')
  Future<void> removeOwner({
    @Path('name') required String name,
    @Path('email') required String email,
  });
}
