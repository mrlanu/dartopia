import 'package:models/models.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../services/mongo_service.dart';

abstract class WorldRepository {
  Future<void> saveWorld(List<MapTile> world);

  Future<List<MapTile>> getPartOfWorldBetweenCoordinates(
      int fromX,
      int toX,
      int fromY,
      int toY,
  );

  Future<bool> dropWorld();
}

class WorldRepositoryMongoImpl implements WorldRepository {
  WorldRepositoryMongoImpl({MongoService? mongoService})
      : _mongoService = mongoService ?? MongoService.instance;

  final MongoService _mongoService;

  @override
  Future<void> saveWorld(List<MapTile> world) => _mongoService.db
        .collection('world')
        .insertMany(world.map((e) => e.toMap()).toList());

  @override
  Future<List<MapTile>> getPartOfWorldBetweenCoordinates(
      int fromX,
      int toX,
      int fromY,
      int toY,) =>
      _mongoService.db
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

  @override
  Future<bool> dropWorld() => _mongoService.db.dropCollection('world');
}
