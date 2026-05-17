import 'package:dio/dio.dart';

import 'session_notifier.dart';

/// Clears the app session when the server returns 401 on protected routes.
class UnauthorizedInterceptor extends Interceptor {
  static const _authPathPrefixes = ['/auth/login', '/auth/signup'];

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final statusCode = err.response?.statusCode;
    if (statusCode == 401 && !_isAuthRequest(err.requestOptions)) {
      SessionNotifier.instance.notifySessionExpired();
    }
    handler.next(err);
  }

  bool _isAuthRequest(RequestOptions options) {
    final path = options.uri.path;
    return _authPathPrefixes.any(path.endsWith);
  }
}
