import 'package:shared_preferences/shared_preferences.dart';

/// Persists access and refresh tokens for the game client.
class TokenStorage {
  TokenStorage._();

  static const accessTokenKey = 'token';
  static const refreshTokenKey = 'refreshToken';
  static const nameKey = 'name';

  static Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required String name,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(accessTokenKey, accessToken);
    await prefs.setString(refreshTokenKey, refreshToken);
    await prefs.setString(nameKey, name);
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(accessTokenKey);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(refreshTokenKey);
  }

  static Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(nameKey);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(accessTokenKey);
    await prefs.remove(refreshTokenKey);
    await prefs.remove(nameKey);
  }
}
