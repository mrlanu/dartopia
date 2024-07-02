import 'dart:convert';
import 'dart:io';
import 'package:models/models.dart';
import 'package:network/network.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  AuthRepo({NetworkClient? networkClient})
      : _networkClient = networkClient ?? NetworkClient.instance;

  final NetworkClient _networkClient;

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
}
