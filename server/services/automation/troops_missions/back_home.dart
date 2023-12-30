import 'package:models/models.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'troop_missions.dart';

class BackHome extends MissionStrategy {
  BackHome({required super.movement,
    required super.mongoService,
    required super.settlementService,});

  @override
  Future<void> handle() async {
    final homeSettlement = await settlementService.recalculateState(
      settlementId: movement.to.villageId,
      untilDateTime: movement.when,
    );
    _addUnits(movement.units, homeSettlement!);
    _addStolenResources(movement.plunder, homeSettlement);
    await settlementService.updateSettlement(settlement: homeSettlement);
    await mongoService.db
        .collection('movements')
        .deleteOne(where.id(movement.id!));
  }

  void _addUnits(List<int> units, Settlement home) {
    final homeUnits = home.units;
    for (var i = 0; i < 10; i++) {
      var amount = homeUnits[i];
      amount += units[i];
      homeUnits[i] = amount;
    }
  }

  void _addStolenResources(List<int> plunder, Settlement home) {
    final storage = home.storage;
    for (var i = 0; i < 4; i++) {
      var res = storage[i];
      res += plunder[i];
      storage[i] = res;
    }
  }
  
}
