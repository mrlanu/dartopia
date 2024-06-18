import 'dart:async';

import 'package:models/models.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../database/database_client.dart';
import '../exceptions/exceptions.dart';

abstract class StatisticsRepository {
  Future<StatisticsModel> createStatistics(StatisticsModel statisticsModel);

  Future<StatisticsResponse> getStatisticsList(
      String playerId, String? page, String sortBy,);

  Future<void> addPopulation({required String playerId, required int amount});
}

class StatisticsRepositoryImpl implements StatisticsRepository {
  StatisticsRepositoryImpl({required DatabaseClient databaseClient})
      : _databaseClient = databaseClient;

  final DatabaseClient _databaseClient;

  @override
  Future<StatisticsModel> createStatistics(
      StatisticsModel statisticsModel,) async {
    try {
      if (_databaseClient.db != null && _databaseClient.db!.isConnected) {
        final response = await _databaseClient.db!
            .collection('statistics')
            .insertOne(statisticsModel.toJson());
        return StatisticsModel.fromJson(response.document!);
      } else {
        throw DatabaseConnectionException();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<StatisticsResponse> getStatisticsList(
    String playerId,
    String? page2,
    String sortBy,
  ) async {
    try {
      const pageSize = 10;
      if (_databaseClient.db != null && _databaseClient.db!.isConnected) {
        final collection = _databaseClient.db!.collection('statistics');

        final totalPlayers = await collection.count();
        final totalPages = (totalPlayers / pageSize).ceil();

        int page;
        if (page2 == null) {
          final index = await collection
              .find(where.sortBy(sortBy, descending: true))
              .toList()
              .then(
                (list) => list.indexWhere((doc) => doc['playerId'] == playerId),
              );
          page = ((index + 1) / pageSize).ceil();
        } else {
          page = int.parse(page2);
        }
        final skip = (page - 1) * pageSize;

        final players = await collection
            .find(
              where.sortBy(sortBy, descending: true).skip(skip).limit(pageSize),
            )
            .map(StatisticsModel.fromJson)
            .toList();

        for (var i = 0; i < players.length; i++) {
          players[i] = players[i].copyWith(position: i + skip + 1);
        }
        return StatisticsResponse(
            modelsList: players,
            currentPage: page,
            totalItems: totalPlayers,
            totalPages: totalPages,
            itemsPerPage: pageSize,);
      } else {
        throw DatabaseConnectionException();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addPopulation(
      {required String playerId, required int amount,}) async {
    try {
      if (_databaseClient.db != null && _databaseClient.db!.isConnected) {
        unawaited(_databaseClient.db!.collection('statistics').update(
              where.eq('playerId', playerId),
              ModifierBuilder().inc('population', amount),),);
      } else {
        throw DatabaseConnectionException();
      }
    } catch (e) {
      rethrow;
    }
  }
}
