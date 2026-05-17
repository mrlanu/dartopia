import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:models/models.dart';
import 'package:network/network.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      : _networkClient = networkClient ?? NetworkClient.instance;

  final NetworkClient _networkClient;
  final _authStatusController = StreamController<AuthStatus>.broadcast();
  bool _clearingSession = false;

  Stream<AuthStatus> get authStatus async* {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final name = prefs.getString('name');

    if (token != null && name != null && !_isTokenExpired(token)) {
      yield AuthenticatedStatus(User(name, token));
    } else if (token != null) {
      await _clearStoredSession(prefs);
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
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', response.data!['token']);
      await prefs.setString('name', response.data!['name']);
      SessionNotifier.instance.reset();
      _authStatusController.add(AuthenticatedStatus(
          User(response.data!['name'], response.data!['token'])));
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  /// Clears stored credentials after 401 or local JWT expiry.
  Future<void> sessionExpired() async {
    if (_clearingSession) {
      return;
    }
    _clearingSession = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      await _clearStoredSession(prefs);
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
      final prefs = await SharedPreferences.getInstance();
      await _clearStoredSession(prefs);
      SessionNotifier.instance.reset();
      _authStatusController.add(const UnauthenticatedStatus());
    } finally {
      _clearingSession = false;
    }
  }

  Future<void> _clearStoredSession(SharedPreferences prefs) async {
    await prefs.remove('token');
    await prefs.remove('name');
  }

  bool _isTokenExpired(String token) {
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
