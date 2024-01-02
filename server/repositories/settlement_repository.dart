import 'package:models/models.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../services/mongo_service.dart';

abstract class SettlementRepository {
  Future<List<ShortSettlementInfo>> getSettlementsIdByUserId(
      {required String userId});

  Future<Settlement?> saveSettlement(Settlement settlement);

  Future<Settlement?> updateSettlement(Settlement settlement);

  Future<Settlement?> getById(String id);

  Future<Settlement?> fetchSettlementByCoordinates({
    required int x,
    required int y,
  });

  Future<TileDetails> getTileDetailsByCoordinates({
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
  SettlementRepositoryMongoImpl({MongoService? mongoService})
      : _mongoService = mongoService ?? MongoService.instance;

  final MongoService _mongoService;

  @override
  Future<List<ShortSettlementInfo>> getSettlementsIdByUserId({
    required String userId,
  }) =>
      _mongoService.db
          .collection('settlements')
          .find(where.eq('userId', userId))
          .map(Settlement.fromMap)
          .map(
            (s) => ShortSettlementInfo(
                isCapital: true,
                settlementId: s.id.$oid,
                name: s.name,
                x: s.x,
                y: s.y),
          )
          .toList();

  @override
  Future<Settlement?> getById(String id) async {
    final objectId = ObjectId.parse(id);
    final document = await _mongoService.db
        .collection('settlements')
        .findOne(where.id(objectId));
    if (document != null) {
      return Settlement.fromMap(document);
    } else {
      return null;
    }
  }

  @override
  Future<Settlement?> fetchSettlementByCoordinates({
    required int x,
    required int y,
  }) async {
    final document = await _mongoService.db
        .collection('settlements')
        .findOne(where.eq('x', x).and(where.eq('y', y)));
    if (document != null) {
      return Settlement.fromMap(document);
    } else {
      return null;
    }
  }

  @override
  Future<TileDetails> getTileDetailsByCoordinates({
    required int x,
    required int y,
  }) async {
    final doc = await _mongoService.db
        .collection('settlements')
        .findOne(where.eq('x', x).and(where.eq('y', y)));
    final settlement = Settlement.fromMap(doc!);
    final tileDetails = TileDetails(
      id: settlement.id.$oid,
      playerName: settlement.userId,
      name: settlement.name,
      x: settlement.x,
      y: settlement.y,
      population: 100,
      distance: 3,
    );
    return tileDetails;
  }

  @override
  Future<Settlement?> saveSettlement(Settlement settlement) async {
    final result = await _mongoService.db
        .collection('settlements')
        .insertOne(settlement.toMap());
    if (result.isSuccess) {
      return settlement;
    } else {
      return null;
    }
  }

  @override
  Future<Settlement?> updateSettlement(Settlement settlement) async {
    final result = await _mongoService.db.collection('settlements').replaceOne(
          where.id(settlement.id),
          settlement.copyWith(lastModified: DateTime.now()).toMap(),
        );
    if (result.isSuccess) {
      return settlement;
    } else {
      return null;
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
      // (to.villageId' == id || ('from.villageId' == id && 'mission' != 'back'))
      selector = where.eq('isMoving', true).and(
            where.eq('to.villageId', id).or(where
                .eq('from.villageId', id)
                .and(where.ne('mission', 'back')),),
          );
    }
    if (isMoving != null && isMoving == false) {
      selector = where.eq('isMoving', false).and(
            where.eq('to.villageId', id).or(where
                .eq('from.villageId', id)
                .and(where.ne('mission', 'back')),),
          );
    }
    return _mongoService.db
        .collection('movements')
        .find(selector)
        .map(Movement.fromMap)
        .toList();
  }

  @override
  Future<List<Movement>> getAllStaticForeignMovementsBySettlementId(
    String id,
  ) =>
      _mongoService.db
          .collection('movements')
          .find(where.eq('to.villageId', id).and(where.eq('isMoving', false)))
          .map(Movement.fromMap)
          .toList();

  @override
  Future<bool> sendUnits(Movement movement) async {
    final result = await _mongoService.db
        .collection('movements')
        .insertOne(movement.toMap());
    return result.document == null;
  }

  @override
  Future<List<Movement>> getMovementsBeforeNow() => _mongoService.db
      .collection('movements')
      .find(where.eq('isMoving', true).and(where.lte('when', DateTime.now())))
      .map(Movement.fromMap)
      .toList();
}
