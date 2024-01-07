import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

sealed class AuthenticationStatus {
  AuthenticationStatus();
}

final class Unknown extends AuthenticationStatus {
  Unknown();
}

final class Authenticated extends AuthenticationStatus {
  Authenticated(
      {required this.token, required this.userId, required this.userName});

  final String token;
  final String userId;
  final String userName;
}

final class Unauthenticated extends AuthenticationStatus {
  Unauthenticated();
}

class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();
  final SharedPreferences _plugin;
  static const keyMap = {
    'keyToken': '__key_token__',
    'keyId': '__key_id__',
    'keyName': '__key_name__',
    'keyEmail': '__key_email__'
  };

  AuthenticationRepository({
    required SharedPreferences plugin,
  }) : _plugin = plugin {}

  String? _getValue(String key) => _plugin.getString(key);

  Future<void> _setValue(String key, String value) =>
      _plugin.setString(key, value);

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    final authToken = _getValue(keyMap['keyToken']!);
    if (authToken != null) {
      final userId = _getValue(keyMap['keyId']!);
      final userName = _getValue(keyMap['keyName']!);
      _controller.add(Authenticated(
          token: authToken, userId: userId!, userName: userName!));
    } else {
      _controller.add(Unauthenticated());
    }
    yield* _controller.stream;
  }

  Future<void> signup({
    required String email,
    required String password,
  }) async {
    final url = Uri.http(Api.baseURL, Api.signup());
    final responseMap = await http.post(url,
        body: json.encode({'email': email, 'password': password, 'name': ''}));
    if (responseMap.statusCode != 200) {
      _controller.add(Unauthenticated());
    } else {
      _success(responseMap);
    }
  }

  Future<void> logIn({
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
  }

  void _success(http.Response responseMap) {
    final response = json.decode(responseMap.body) as Map<String, dynamic>;
    _setValue(keyMap['keyToken']!, response['token']);
    _setValue(keyMap['keyId']!, response['id']);
    _setValue(keyMap['keyName']!, response['name']);
    _controller.add(Authenticated(
        token: response['token'],
        userId: response['id'],
        userName: response['name']));
  }

  void logOut() {
    keyMap.entries.forEach((e) => _plugin.remove(keyMap[e.key]!));
    _controller.add(Unauthenticated());
  }

  void dispose() => _controller.close();
}
