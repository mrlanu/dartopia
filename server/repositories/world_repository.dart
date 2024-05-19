import 'package:models/models.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../database/database_client.dart';
import '../exceptions/exceptions.dart';

abstract class WorldRepository {
  Future<void> saveWorld(List<MapTile> world);

  Future<void> updateMapTile(MapTile tile);

  Future<List<MapTile>> getPartOfWorldBetweenCoordinates(
    int fromX,
    int toX,
    int fromY,
    int toY,
  );

  Future<MapTile> getMapTileByCoordinates(int x, int y);

  Future<bool> dropWorld();
}

class WorldRepositoryMongoImpl implements WorldRepository {
  WorldRepositoryMongoImpl({required DatabaseClient databaseClient})
      : _databaseClient = databaseClient;

  final DatabaseClient _databaseClient;

  @override
  Future<void> saveWorld(List<MapTile> world) {
    try {
      if (_databaseClient.db != null && _databaseClient.db!.isConnected) {
        return _databaseClient.db!
            .collection('world')
            .insertMany(world.map((e) => e.toMap()).toList());
      } else {
        throw DatabaseConnectionException();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<MapTile>> getPartOfWorldBetweenCoordinates(
    int fromX,
    int toX,
    int fromY,
    int toY,
  ) {
    try {
      if (_databaseClient.db != null && _databaseClient.db!.isConnected) {
        return _databaseClient.db!
            .collection('world')
            .find(
              where
                  .gt('corX', fromX)
                  .and(where.lt('corX', toX))
                  .and(where.gt('corY', fromY))
                  .and(where.lt('corY', toY)),
            )
            .map(MapTile.fromMap)
            .toList();
      } else {
        throw DatabaseConnectionException();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<MapTile> getMapTileByCoordinates(int x, int y) async {
    try {
      if (_databaseClient.db != null && _databaseClient.db!.isConnected) {
        final tileMap = await _databaseClient.db!.collection('world').findOne(
              where.eq('corX', x).and(where.eq('corY', y)),
            );
        return MapTile.fromMap(tileMap!);
      } else {
        throw DatabaseConnectionException();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateMapTile(MapTile tile) {
    try {
      if (_databaseClient.db != null && _databaseClient.db!.isConnected) {
        return _databaseClient.db!
            .collection('world')
            .replaceOne(where.id(tile.id), tile.toMap());
      } else {
        throw DatabaseConnectionException();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> dropWorld() {
    try {
      if (_databaseClient.db != null && _databaseClient.db!.isConnected) {
        _databaseClient.db!.dropCollection('settlements');
        _databaseClient.db!.dropCollection('statistics');
        _databaseClient.db!.dropCollection('users');
        _databaseClient.db!.dropCollection('movements');
        return _databaseClient.db!.dropCollection('world');
      } else {
        throw DatabaseConnectionException();
      }
    } catch (e) {
      rethrow;
    }
  }
}
