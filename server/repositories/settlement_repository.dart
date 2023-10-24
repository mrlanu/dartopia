import 'package:models/models.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../services/mongo_service.dart';

abstract class SettlementRepository {
  Future<Settlement?> saveSettlement(Settlement settlement);
  Future<Settlement?> updateSettlement(Settlement settlement);
  Future<Settlement?> getById(String id);
}

class SettlementRepositoryMongoImpl implements SettlementRepository {
  SettlementRepositoryMongoImpl({MongoService? mongoService})
      : _mongoService = mongoService ?? MongoService.instance;

  final MongoService _mongoService;

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
    final result = await _mongoService.db
        .collection('settlements')
        .replaceOne(where.id(settlement.id), settlement.toMap());
    if (result.isSuccess) {
      return settlement;
    } else {
      return null;
    }
  }
}
