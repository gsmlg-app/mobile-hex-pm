import 'package:dio/dio.dart';

abstract class AuthInterceptor extends Interceptor {
  /// Get auth information on given route for the given type.
  /// Can return an empty list if type is not present on auth data or
  /// if route doesn't need authentication.
  List<Map<String, String>> getAuthInfo(
      RequestOptions route, bool Function(Map<String, String> secure) handles) {
    if (route.extra.containsKey('secure')) {
      final auth = route.extra['secure'] as List<Map<String, String>>;
      return auth.where((secure) => handles(secure)).toList();
    }
    return [];
  }
}

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
