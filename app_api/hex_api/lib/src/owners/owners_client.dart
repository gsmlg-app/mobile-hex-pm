// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/add_owner_request.dart';
import '../models/owner.dart';

part 'owners_client.g.dart';

@RestApi()
abstract class OwnersClient {
  factory OwnersClient(Dio dio, {String? baseUrl}) = _OwnersClient;

  /// Fetch Package Owners
  @GET('/packages/{name}/owners')
  Future<List<Owner>> getOwners({
    @Path('name') required String name,
  });

  /// Add a Package Owner
  @PUT('/packages/{name}/owners/{email}')
  Future<void> addOwner({
    @Path('name') required String name,
    @Path('email') required String email,
    @Body() AddOwnerRequest? body,
  });

  /// Remove a Package Owner
  @DELETE('/packages/{name}/owners/{email}')
  Future<void> removeOwner({
    @Path('name') required String name,
    @Path('email') required String email,
  });
}
