import 'dart:async';
import 'dart:convert';
import 'dart:io';
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

  Stream<AuthStatus> get authStatus async* {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final name = prefs.getString('name');
    if (token != null) {
      yield AuthenticatedStatus(User(name!, token));
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
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', response.data!['token']);
      await prefs.setString('name', response.data!['name']);
      _authStatusController.add(AuthenticatedStatus(
          User(response.data!['name'], response.data!['token'])));
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
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
