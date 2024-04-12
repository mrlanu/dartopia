import 'package:models/models.dart';

import '../repositories/statistics_repository.dart';

abstract class StatisticsService {
  Future<StatisticsModel> createStatistics({
    required String playerId,
    required String playerName,
    required List<List<int>> buildings,
  });

  Future<StatisticsResponse> getStatisticsList(
      {required String playerId, required String sortBy, String? page,});
}

class StatisticsServiceImpl implements StatisticsService {
  StatisticsServiceImpl({required StatisticsRepository statisticsRepository})
      : _statisticsRepository = statisticsRepository;
  final StatisticsRepository _statisticsRepository;

  @override
  Future<StatisticsModel> createStatistics({
    required String playerId,
    required String playerName,
    required List<List<int>> buildings,
  }) async {
    final population = buildings
        .map((b) => buildingSpecefication[b[1]]!.getPopulation(b[2]))
        .reduce((value, element) => value + element);
    final statModel = StatisticsModel(
      playerId: playerId,
      playerName: playerName,
      population: population,
      allianceName: '',
    );
    return _statisticsRepository.createStatistics(statModel);
  }

  @override
  Future<StatisticsResponse> getStatisticsList(
      {required String playerId, required String sortBy, String? page,}) {
    return _statisticsRepository.getStatisticsList(playerId, page, sortBy);
  }
}
