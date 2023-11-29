import 'package:mongo_dart/mongo_dart.dart';

import '../repositories/settlement_repository.dart';
import 'mongo_service.dart';
import 'settlements_service.dart';

class Automation {
  Automation({SettlementService? settlementService})
      : _settlementService = settlementService ??
            SettlementServiceImpl(
              settlementRepository: SettlementRepositoryMongoImpl(),
            );
  final SettlementService _settlementService;

  Future<void> main() async {
    final mongo = MongoService.instance;
    final movements = await _settlementService.getMovementsBeforeNow();

    for (final m in movements) {
      print('Perform attacks...');
      final offense = await _settlementService.recalculateState(
        settlementId: m.from.villageId,
        untilDateTime: m.when,
      );
      final defense = await _settlementService.recalculateState(
        settlementId: m.to.villageId,
        untilDateTime: m.when,
      );
      await _settlementService.updateSettlement(
        settlement: offense!
            .copyWith(storage: offense.storage.map((e) => e + 100).toList()),
      );
      await _settlementService.updateSettlement(
        settlement: defense!
            .copyWith(storage: defense.storage.map((e) => e - 100).toList()),
      );
      print('Attack from ${m.from} to ${m.to} has been performed');
      await mongo.db.collection('movements').deleteOne(where.id(m.id));
    }

    await mongo.closeDb();
  }
}
