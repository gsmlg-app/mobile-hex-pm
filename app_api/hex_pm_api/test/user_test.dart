import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hex_pm_api/hex_pm_api.dart';
import 'package:test/test.dart';

// tests for User
void main() async {
  final dio = Dio();
  final String? token = Platform.environment['HEX_API_KEY'];
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['Authorization'] = token;
        return handler.next(options);
      },
      onResponse: (response, handler) {},
      onError: (error, handler) {},
    ),
  );
  final hexApi = HexPmApi(dio, baseUrl: 'https://hex.pm/api');
  final userApi = hexApi.users;
  final resp = await userApi.getCurrentUser();
  final UserWithOrgs instance = resp;

  group(User, () {
    // User's unique username.
    // String username
    test('to test the property `username`', () async {
      expect(instance.username, isNotNull);
    });

    // User's primary email address.
    // String email
    test('to test the property `email`', () async {
      expect(instance.email, isNotNull);
    });

    // DateTime insertedAt
    test('to test the property `insertedAt`', () async {
      expect(instance.insertedAt, isNotNull);
    });

    // DateTime updatedAt
    test('to test the property `updatedAt`', () async {
      expect(instance.updatedAt, isNotNull);
    });

    // String url
    test('to test the property `url`', () async {
      expect(instance.url, isNotNull);
    });
  });
}
