import 'package:models/models.dart';
import 'package:network/network.dart';

abstract class StatisticsRepository {
  Future<StatisticsResponse> fetchStatistics({
    String? page,
    required String sort,
  });
}

class StatisticsRepositoryImpl implements StatisticsRepository {
  StatisticsRepositoryImpl({NetworkClient? networkClient})
      : _networkClient = networkClient ?? NetworkClient.instance;

  final NetworkClient _networkClient;

  @override
  Future<StatisticsResponse> fetchStatistics(
      {String? page, required String sort}) async {
    try {
      final response = await _networkClient
          .get<Map<String, dynamic>>(Api.fetchStatistics(page, sort));
      final result = StatisticsResponse.fromJson(response.data!);
      return result;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }
}
