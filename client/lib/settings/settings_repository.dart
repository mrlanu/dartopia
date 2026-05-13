import 'package:models/models.dart';
import 'package:network/network.dart';

abstract class SettingsRepository {
  Future<GameSettings> fetchSettings();
}

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl({NetworkClient? networkClient})
      : _networkClient = networkClient ?? NetworkClient.instance;

  final NetworkClient _networkClient;

  @override
  Future<GameSettings> fetchSettings() async {
    try {
      final response = await _networkClient.get<Map<String, dynamic>>(
        Api.fetchSettings(),
      );
      return GameSettings.fromJson(response.data!);
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }
}
