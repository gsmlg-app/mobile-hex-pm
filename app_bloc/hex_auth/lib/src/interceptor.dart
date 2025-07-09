//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:dio/dio.dart';
import 'package:hex_api/src/auth/auth.dart';

class ApiAuthInterceptor extends AuthInterceptor {
  final String token;

  ApiAuthInterceptor(this.token);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    options.headers['Authorization'] = token;

    super.onRequest(options, handler);
  }
}
