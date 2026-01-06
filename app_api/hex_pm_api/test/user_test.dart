import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hex_pm_api/hex_pm_api.dart';
import 'package:test/test.dart';

// Integration tests for User - requires HEX_API_KEY environment variable
void main() {
  final String? token = Platform.environment['HEX_API_KEY'];

  // Skip integration tests if API key is not available (e.g., in CI)
  if (token == null || token.isEmpty) {
    test('skipped - HEX_API_KEY not set', () {
      // This test is intentionally empty - integration tests require API key
    }, skip: 'HEX_API_KEY environment variable not set');
    return;
  }

  final dio = Dio();
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

  group(User, () {
    late UserWithOrgs instance;

    setUpAll(() async {
      final userApi = hexApi.users;
      instance = await userApi.getCurrentUser();
    });
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
