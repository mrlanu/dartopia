import 'dart:convert';
import 'dart:io';
import 'package:cache_client/cache_client.dart';
import 'package:models/models.dart';
import 'package:network/network.dart';

class AuthRepo {
  AuthRepo({CacheClient? cacheClient, NetworkClient? networkClient})
      : _cacheClient = cacheClient ?? CacheClient.instance,
        _networkClient = networkClient ?? NetworkClient.instance;

  final CacheClient _cacheClient;
  final NetworkClient _networkClient;

  Future<void> signup({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _networkClient.post<Map<String, dynamic>>(
          Api.signup(),
          data:
          json.encode({'email': email, 'password': password,
            'name': _trimEmail(email), 'roles': ['user', 'mod']}));
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
          data: json.encode({'email': email, 'password': password})
    );
    await _cacheClient.setAccessToken(accessToken: response.data!['token']);
    await _cacheClient.setUsername(name: response.data!['name']);
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
