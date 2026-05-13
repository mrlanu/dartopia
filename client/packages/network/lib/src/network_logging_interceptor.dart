import 'dart:convert';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';

const bool _kReleaseMode = bool.fromEnvironment('dart.vm.product');
const bool _kForceNetworkLog = bool.fromEnvironment('NETWORK_LOG', defaultValue: false);

/// Dio interceptor that logs each call to the developer console (DevTools / `flutter run`).
///
/// Enabled when **not** in release mode (`dart.vm.product`), or when the app is built with
/// `--dart-define=NETWORK_LOG=true` (useful for logging in release builds).
class NetworkLoggingInterceptor extends Interceptor {
  static const String _startMsExtraKey = 'dartopia.network.log_start_ms';

  static bool get isEnabled => !_kReleaseMode || _kForceNetworkLog;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (isEnabled) {
      options.extra[_startMsExtraKey] = DateTime.now().millisecondsSinceEpoch;
      developer.log(
        '--> ${options.method} ${options.uri}',
        name: 'Network',
      );
      final snippet = _bodySnippet(options.data);
      if (snippet != null) {
        developer.log('    $snippet', name: 'Network');
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (isEnabled) {
      final options = response.requestOptions;
      final start = options.extra[_startMsExtraKey] as int?;
      final elapsedMs = start == null
          ? null
          : DateTime.now().millisecondsSinceEpoch - start;
      final timing = elapsedMs == null ? '' : ' (${elapsedMs}ms)';
      developer.log(
        '<-- ${response.statusCode} ${options.method} ${options.uri}$timing',
        name: 'Network',
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (isEnabled) {
      final options = err.requestOptions;
      final start = options.extra[_startMsExtraKey] as int?;
      final elapsedMs = start == null
          ? null
          : DateTime.now().millisecondsSinceEpoch - start;
      final timing = elapsedMs == null ? '' : ' (${elapsedMs}ms)';
      final code = err.response?.statusCode;
      final status = code == null ? '' : ' [$code]';
      developer.log(
        '<-- ERROR ${options.method} ${options.uri}$status$timing ${err.message}',
        name: 'Network',
      );
    }
    handler.next(err);
  }

  static String? _bodySnippet(Object? data) {
    if (data == null) {
      return null;
    }
    if (data is FormData) {
      return 'body: FormData (${data.fields.length} fields, '
          '${data.files.length} files)';
    }
    try {
      if (data is Map || data is List) {
        final s = jsonEncode(data);
        return 'body: ${_truncate(s)}';
      }
      if (data is String) {
        return 'body: ${_truncate(data)}';
      }
      if (data is Stream) {
        return 'body: (stream)';
      }
      return 'body: ${_truncate(data.toString())}';
    } catch (_) {
      return 'body: (unencodable)';
    }
  }

  static String _truncate(String s, [int max = 400]) {
    if (s.length <= max) {
      return s;
    }
    return '${s.substring(0, max)}…';
  }
}
