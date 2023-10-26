import 'dart:io';

import 'package:models/models.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../repositories/settlement_repository.dart';

abstract class SettlementService {
  Future<Settlement?> recalculateState({
    required String settlementId,
    DateTime? untilDateTime,
  });

  Future<String?> foundNewSettlement({
    required String userId,
  });
}

class SettlementServiceImpl extends SettlementService {
  SettlementServiceImpl({required SettlementRepository settlementRepository})
      : _settlementRepository = settlementRepository;
  final SettlementRepository _settlementRepository;

  @override
  Future<Settlement?> recalculateState({
    required String settlementId,
    DateTime? untilDateTime,
  }) async {
    untilDateTime ??= DateTime.now();

    final settlement = await _settlementRepository.getById(settlementId);
    final movements =
        await _settlementRepository.getAllMovementsBySettlementId(settlementId);
    settlement!.calculateProducedGoods();

    return _settlementRepository
        .updateSettlement(settlement.copyWith(lastModified: DateTime.now()));
  }

  @override
  Future<String?> foundNewSettlement({required String userId}) async {
    final newSettlement = Settlement(id: ObjectId(), userId: userId);
    final result = await _settlementRepository.saveSettlement(newSettlement);
    return result?.id.$oid;
  }
}
