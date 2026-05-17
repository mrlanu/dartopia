import 'package:dio/dio.dart';

/// Legacy interceptor kept for ordering; session expiry is handled by
/// [TokenRefreshInterceptor] after a failed refresh attempt.
class UnauthorizedInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }
}
