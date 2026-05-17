import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'session_notifier.dart';

/// Attempts to refresh the access token on 401, then retries the failed request.
class TokenRefreshInterceptor extends Interceptor {
  TokenRefreshInterceptor(this._dio);

  final Dio _dio;

  /// Set by [AuthRepo] at startup. Returns true when new tokens were stored.
  static Future<bool> Function()? onRefreshTokens;

  static const _authPaths = [
    '/auth/login',
    '/auth/signup',
    '/auth/refresh',
    '/auth/logout',
  ];

  static Future<bool>? _refreshInFlight;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (!_shouldAttemptRefresh(err)) {
      handler.next(err);
      return;
    }

    final refreshed = await _refreshTokens();
    if (!refreshed) {
      SessionNotifier.instance.notifySessionExpired();
      handler.next(err);
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('token');
      final options = err.requestOptions;
      options.extra['retried'] = true;
      options.headers['Authorization'] = 'Bearer $accessToken';
      final response = await _dio.fetch(options);
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  bool _shouldAttemptRefresh(DioException err) {
    if (err.response?.statusCode != 401) {
      return false;
    }
    if (_isAuthPath(err.requestOptions.uri.path)) {
      return false;
    }
    if (err.requestOptions.extra['retried'] == true) {
      return false;
    }
    return onRefreshTokens != null;
  }

  bool _isAuthPath(String path) {
    return _authPaths.any((authPath) => path.endsWith(authPath));
  }

  Future<bool> _refreshTokens() {
    final inFlight = _refreshInFlight;
    if (inFlight != null) {
      return inFlight;
    }

    final future = onRefreshTokens!();
    _refreshInFlight = future;
    return future.whenComplete(() => _refreshInFlight = null);
  }
}
