import 'package:models/models.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../database/database_client.dart';
import '../exceptions/exceptions.dart';

abstract class SettlementRepository {
  Future<List<ShortSettlementInfo>> getSettlementsIdByUserId({
    required String userId,
  });

  Future<Settlement?> saveSettlement(Settlement settlement);

  Future<Settlement> updateSettlement(Settlement settlement);

  Future<Settlement?> updateSettlementWithoutLastModified(
      Settlement settlement,);

  Future<Settlement?> getById(String id);

  Future<Settlement?> fetchSettlementByCoordinates({
    required int x,
    required int y,
  });

  Future<Settlement> getSettlementByCoordinates({
    required int x,
    required int y,
  });

  //movements
  Future<List<Movement>> getAllMovementsBySettlementId({
    required String id,
    bool? isMoving,
  });

  Future<List<Movement>> getMovementsBeforeNow();

  Future<List<Movement>> getAllStaticForeignMovementsBySettlementId(String id);

  Future<bool> sendUnits(Movement movement);
}

class SettlementRepositoryMongoImpl implements SettlementRepository {
  SettlementRepositoryMongoImpl({required DatabaseClient databaseClient})
      : _databaseClient = databaseClient;

  final DatabaseClient _databaseClient;

  @override
  Future<List<ShortSettlementInfo>> getSettlementsIdByUserId({
    required String userId,
  }) {
    try {
      if (_databaseClient.db != null && _databaseClient.db!.isConnected) {
        final result = _databaseClient.db!
            .collection('settlements')
            .find(where.eq('userId', userId))
            .map(Settlement.fromMap)
            .map(
              (s) => ShortSettlementInfo(
                isCapital: true,
                settlementId: s.id.$oid,
                name: s.name,
                x: s.x,
                y: s.y,
              ),
            )
            .toList();
        return result;
      } else {
        throw DatabaseConnectionException();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Settlement?> getById(String id) async {
    final objectId = ObjectId.parse(id);
    try {
      if (_databaseClient.db != null && _databaseClient.db!.isConnected) {
        final document = await _databaseClient.db!
            .collection('settlements')
            .findOne(where.id(objectId));
        if (document != null) {
          return Settlement.fromMap(document);
        } else {
          return null;
        }
      } else {
        throw DatabaseConnectionException();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Settlement?> fetchSettlementByCoordinates({
    required int x,
    required int y,
  }) async {
    try {
      if (_databaseClient.db != null && _databaseClient.db!.isConnected) {
        final document = await _databaseClient.db!
            .collection('settlements')
            .findOne(where.eq('x', x).and(where.eq('y', y)));
        if (document != null) {
          return Settlement.fromMap(document);
        } else {
          return null;
        }
      } else {
        throw DatabaseConnectionException();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Settlement> getSettlementByCoordinates({
    required int x,
    required int y,
  }) async {
    try {
      if (_databaseClient.db != null && _databaseClient.db!.isConnected) {
        final doc = await _databaseClient.db!
            .collection('settlements')
            .findOne(where.eq('x', x).and(where.eq('y', y)));
        final settlement = Settlement.fromMap(doc!);
        return settlement;
      } else {
        throw DatabaseConnectionException();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Settlement?> saveSettlement(Settlement settlement) async {
    try {
      if (_databaseClient.db != null && _databaseClient.db!.isConnected) {
        final result = await _databaseClient.db!
            .collection('settlements')
            .insertOne(settlement.toMap());
        if (result.isSuccess) {
          return settlement;
        } else {
          return null;
        }
      } else {
        throw DatabaseConnectionException();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Settlement> updateSettlement(Settlement settlement) async {
    try {
      if (_databaseClient.db != null && _databaseClient.db!.isConnected) {
        await _databaseClient.db!.collection('settlements').replaceOne(
                  where.id(settlement.id),
                  settlement.copyWith(lastModified: DateTime.now()).toMap(),
                );
        return settlement;
      } else {
        throw DatabaseConnectionException();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Settlement?> updateSettlementWithoutLastModified(
      Settlement settlement,) async {
    try {
      if (_databaseClient.db != null && _databaseClient.db!.isConnected) {
        final result =
            await _databaseClient.db!.collection('settlements').replaceOne(
                  where.id(settlement.id),
                  settlement.toMap(),
                );
        if (result.isSuccess) {
          return settlement;
        } else {
          return null;
        }
      } else {
        throw DatabaseConnectionException();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Movement>> getAllMovementsBySettlementId({
    required String id,
    bool? isMoving,
  }) {
    // 'to.villageId' == id || ('from.villageId' == id && 'mission' != 'back')
    var selector = where
        .eq('to.villageId', id)
        .or(where.eq('from.villageId', id).and(where.ne('mission', 'back')));
    if (isMoving != null && isMoving == true) {
      // 'isMoving' == true' &&
      // (to.villageId' == id ||
      // ('from.villageId' == id && 'mission' != 'back'))
      selector = where.eq('moving', true).and(
            where.eq('to.villageId', id).or(
                  where
                      .eq('from.villageId', id)
                      .and(where.ne('mission', 'back')),
                ),
          );
    }
    if (isMoving != null && isMoving == false) {
      selector = where.eq('moving', false).and(
            where.eq('to.villageId', id).or(
                  where
                      .eq('from.villageId', id)
                      .and(where.ne('mission', 'back')),
                ),
          );
    }
    try {
      if (_databaseClient.db != null && _databaseClient.db!.isConnected) {
        return _databaseClient.db!
            .collection('movements')
            .find(selector)
            .map(Movement.fromMap)
            .toList();
      } else {
        throw DatabaseConnectionException();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Movement>> getAllStaticForeignMovementsBySettlementId(
    String id,
  ) {
    try {
      if (_databaseClient.db != null && _databaseClient.db!.isConnected) {
        return _databaseClient.db!
            .collection('movements')
            .find(where.eq('to.villageId', id).and(where.eq('moving', false)))
            .map(Movement.fromMap)
            .toList();
      } else {
        throw DatabaseConnectionException();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> sendUnits(Movement movement) async {
    try {
      if (_databaseClient.db != null && _databaseClient.db!.isConnected) {
        final result = await _databaseClient.db!
            .collection('movements')
            .insertOne(movement.toMap());
        return result.document == null;
      } else {
        throw DatabaseConnectionException();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Movement>> getMovementsBeforeNow() {
    try {
      if (_databaseClient.db != null && _databaseClient.db!.isConnected) {
        return _databaseClient.db!
            .collection('movements')
            .find(
              where.eq('moving', true).and(where.lte('when', DateTime.now())),
            )
            .map(Movement.fromMap)
            .toList();
      } else {
        throw DatabaseConnectionException();
      }
    } catch (e) {
      rethrow;
    }
  }
}
