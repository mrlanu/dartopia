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
  Authenticated({required this.token});

  final String token;
}

final class Unauthenticated extends AuthenticationStatus {
  Unauthenticated();
}

class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();
  final SharedPreferences _plugin;
  static const kAuthCollectionKey = '__auth_collection_key__';

  AuthenticationRepository({
    required SharedPreferences plugin,
  }) : _plugin = plugin {}

  String? _getValue(String key) => _plugin.getString(key);

  Future<void> _setValue(String key, String value) =>
      _plugin.setString(key, value);

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    final authJson = _getValue(kAuthCollectionKey);
    if (authJson != null) {
      _controller.add(Authenticated(token: authJson));
    } else {
      _controller.add(Unauthenticated());
    }
    yield* _controller.stream;
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
      final response = json.decode(responseMap.body) as Map<String, dynamic>;
      _setValue(kAuthCollectionKey, jsonEncode(response['token']));
      _controller.add(Authenticated(token: response['token']));
    }
  }

  void logOut() {
    _plugin.remove(kAuthCollectionKey);
    _controller.add(Unauthenticated());
  }

  void dispose() => _controller.close();
}
