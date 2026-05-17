import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:models/models.dart';
import 'package:network/network.dart';
import 'token_storage.dart';

export 'token_storage.dart';

sealed class AuthStatus {
  const AuthStatus();

  User? get user => switch (this) {
        AuthenticatedStatus(:final user) => user,
        _ => null,
      };
}

class UnknownStatus extends AuthStatus {
  const UnknownStatus();
}

class AuthenticatedStatus extends AuthStatus {
  @override
  final User user;

  const AuthenticatedStatus(this.user);
}

class UnauthenticatedStatus extends AuthStatus {
  const UnauthenticatedStatus();
}

class AuthRepo {
  AuthRepo({NetworkClient? networkClient})
      : _networkClient = networkClient ?? NetworkClient.instance {
    TokenRefreshInterceptor.onRefreshTokens = tryRefresh;
  }

  final NetworkClient _networkClient;
  final _authStatusController = StreamController<AuthStatus>.broadcast();
  bool _clearingSession = false;

  Stream<AuthStatus> get authStatus async* {
    final accessToken = await TokenStorage.getAccessToken();
    final refreshToken = await TokenStorage.getRefreshToken();
    final name = await TokenStorage.getName();

    if (accessToken != null &&
        name != null &&
        !_isAccessTokenExpired(accessToken)) {
      yield AuthenticatedStatus(User(name, accessToken));
    } else if (refreshToken != null && name != null) {
      final refreshed = await tryRefresh();
      if (refreshed) {
        final newAccess = await TokenStorage.getAccessToken();
        final storedName = await TokenStorage.getName();
        if (newAccess != null && storedName != null) {
          yield AuthenticatedStatus(User(storedName, newAccess));
        } else {
          yield const UnauthenticatedStatus();
        }
      } else {
        await TokenStorage.clear();
        yield const UnauthenticatedStatus();
      }
    } else if (accessToken != null || refreshToken != null) {
      await TokenStorage.clear();
      SessionNotifier.instance.reset();
      yield const UnauthenticatedStatus();
    } else {
      yield const UnauthenticatedStatus();
    }

    yield* _authStatusController.stream;
  }

  Future<void> signup({
    required String email,
    required String password,
  }) async {
    try {
      final response =
          await _networkClient.post<Map<String, dynamic>>(Api.signup(),
              data: json.encode({
                'email': email,
                'password': password,
                'name': _trimEmail(email),
                'roles': ['user', 'mod']
              }));
      if (response.statusCode == HttpStatus.created) {
        return;
      }
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _networkClient.post<Map<String, dynamic>>(
          Api.signin(),
          data: json.encode({'email': email, 'password': password}));
      await _persistAuthResponse(response.data!);
      SessionNotifier.instance.reset();
      final accessToken = await TokenStorage.getAccessToken();
      final name = await TokenStorage.getName();
      _authStatusController.add(
          AuthenticatedStatus(User(name!, accessToken!)));
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  /// Exchanges a refresh token for a new access + refresh pair.
  Future<bool> tryRefresh() async {
    final refreshToken = await TokenStorage.getRefreshToken();
    if (refreshToken == null) {
      return false;
    }

    try {
      final response = await _networkClient.post<Map<String, dynamic>>(
        Api.refresh(),
        data: json.encode({'refreshToken': refreshToken}),
      );
      await _persistAuthResponse(response.data!);
      SessionNotifier.instance.reset();

      final accessToken = await TokenStorage.getAccessToken();
      final name = await TokenStorage.getName();
      if (accessToken != null && name != null) {
        _authStatusController.add(
            AuthenticatedStatus(User(name, accessToken)));
      }
      return true;
    } on DioException {
      return false;
    }
  }

  Future<void> sessionExpired() async {
    if (_clearingSession) {
      return;
    }
    _clearingSession = true;
    try {
      await TokenStorage.clear();
      _authStatusController.add(const UnauthenticatedStatus());
    } finally {
      _clearingSession = false;
    }
  }

  Future<void> logout() async {
    if (_clearingSession) {
      return;
    }
    _clearingSession = true;
    try {
      final refreshToken = await TokenStorage.getRefreshToken();
      if (refreshToken != null) {
        try {
          await _networkClient.post<void>(
            Api.logout(),
            data: json.encode({'refreshToken': refreshToken}),
          );
        } on DioException {
          // Clear local session even if revoke fails (offline / expired).
        }
      }
      await TokenStorage.clear();
      SessionNotifier.instance.reset();
      _authStatusController.add(const UnauthenticatedStatus());
    } finally {
      _clearingSession = false;
    }
  }

  Future<void> _persistAuthResponse(Map<String, dynamic> data) async {
    final accessToken = data['token'] as String?;
    final refreshToken = data['refreshToken'] as String?;
    final name = data['name'] as String?;

    if (accessToken == null || refreshToken == null || name == null) {
      throw StateError('Auth response missing token, refreshToken, or name');
    }

    await TokenStorage.saveSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      name: name,
    );
  }

  bool _isAccessTokenExpired(String token) {
    try {
      return Jwt.isExpired(token);
    } catch (_) {
      return true;
    }
  }

  String _trimEmail(String email) {
    final atIndex = email.indexOf('@');
    if (atIndex != -1) {
      final name = email.substring(0, atIndex);
      return _capitalizeFirst(name);
    } else {
      return email;
    }
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  void dispose() => _authStatusController.close();
}

class User {
  const User(this.name, this.token);

  final String name;
  final String token;

  static const empty = User('-', '-');
}
