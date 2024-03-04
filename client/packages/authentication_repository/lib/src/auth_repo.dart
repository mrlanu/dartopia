import 'dart:convert';
import 'dart:io';
import 'package:cache_client/cache_client.dart';
import 'package:dio/dio.dart';
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
          json.encode({'email': email, 'password': password, 'name': ''}));
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
    } on DioException catch (e) {
    throw NetworkException.fromDioError(e);
    }
  }

/*Future<void> logIn({
    required String email,
    required String password,
  }) async {
    final url = Uri.http(Api.baseURL, Api.signin());
    final responseMap = await http.post(url,
        body: json.encode({'email': email, 'password': password}));
    if (responseMap.statusCode != 200) {
      _controller.add(Unauthenticated());
    } else {
      _success(responseMap);
    }
  }*/

/*void _success(http.Response responseMap) {
    final response = json.decode(responseMap.body) as Map<String, dynamic>;
    _setValue(keyMap['keyToken']!, response['token']);
    _setValue(keyMap['keyId']!, response['id']);
    _setValue(keyMap['keyName']!, response['name']);
    _controller.add(Authenticated(
        token: response['token'],
        userId: response['id'],
        userName: response['name']));
  }*/

}
