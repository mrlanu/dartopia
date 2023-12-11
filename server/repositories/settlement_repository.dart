import 'package:models/models.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../services/mongo_service.dart';

abstract class SettlementRepository {
  Future<List<ShortSettlementInfo>> getSettlementsIdByUserId(
      {required String userId});

  Future<Settlement?> saveSettlement(Settlement settlement);

  Future<Settlement?> updateSettlement(Settlement settlement);

  Future<Settlement?> getById(String id);

  Future<TileDetails> getTileDetailsByCoordinates({
    required int x,
    required int y,
  });

  //movements
  Future<List<Movement>> getAllMovementsBySettlementId(String id);

  Future<List<Movement>> getMovementsBeforeNow();

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
          .map((s) => ShortSettlementInfo(
              isCapital: true,
              settlementId: s.id.$oid,
              name: s.name,
              x: s.x,
              y: s.y),)
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
  Future<List<Movement>> getAllMovementsBySettlementId(String id) =>
      _mongoService.db
          .collection('movements')
          .find(where.eq('from.villageId', id).or(where.eq('to.villageId', id)))
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
      .find(where.lte('when', DateTime.now()))
      .map(Movement.fromMap)
      .toList();
}
