import 'dart:math';

import 'package:models/models.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../../battle/battle.dart';
import '../../battle/main_battle.dart';
import 'troop_missions.dart';

class Attack extends MissionStrategy {
  Attack(
      {required super.movement,
      required super.mongoService,
      required super.settlementService});

  @override
  Future<void> handle() async {
    final offenseSettlement = await settlementService.recalculateState(
      settlementId: movement.from.villageId,
      untilDateTime: movement.when,
    );
    final defenseSettlement = await settlementService.recalculateState(
      settlementId: movement.to.villageId,
      untilDateTime: movement.when,
    );

    final battle = Battle();

    const battleField = BattleField(tribe: 2, population: 100);
    final off = Army(
      side: ESide.OFF,
      population: 100,
      units: UnitsConst.UNITS[2],
      numbers: movement.units,
      mission: movement.mission,
    );

    final ownDef = Army(
      side: ESide.DEF,
      population: 100,
      units: UnitsConst.UNITS[2],
      numbers: defenseSettlement!.units,
    );

    final sidesArmy = [ownDef, off];

    final battleResults = battle.perform(battleField, sidesArmy);
    final plunder = _returnOff(sidesArmy[sidesArmy.length - 1], defenseSettlement);
    sidesArmy.removeAt(sidesArmy.length -1);
    _updateDef(defenseSettlement, sidesArmy, []);
    await settlementService.updateSettlement(settlement: defenseSettlement);
  }

  void _updateDef(Settlement def, List<Army> sidesArmy, List<int>? defEntities) {
    def.units = sidesArmy[0].numbers;
    // start from 1 because there is off army on the front in sidesArmy
    for (var i = 1; i < sidesArmy.length; i++){
      /*final currentDef = defEntities.get(i - 1);
      if (sidesArmy.get(i).getNumbers().stream().reduce(0, Integer::sum) == 0){
        engineService.getCombatGroupRepository().deleteById(currentDef.getId());
        continue;
      }
      currentDef.setUnits(sidesArmy.get(i).getNumbers());
      engineService.getCombatGroupRepository().save(currentDef);*/
    }
  }

  Future<List<int>> _returnOff(Army offArmy, Settlement def) async {
    //off has been completely destroyed
    if (offArmy.numbers.reduce(
          (value, element) => value + element,
        ) ==
        0) {
      await mongoService.db
          .collection('movements')
          .deleteOne(where.id(movement.id!));
      return [0, 0, 0, 0];
    }
    final plunder = _calculatePlunder(offArmy.numbers, def);
    _subtractStolenResources(plunder, def);
    movement = movement.copyWith(
        from: movement.to,
        to: movement.from,
        units: offArmy.numbers,
        plunder: plunder,
        mission: Mission.back,
        when: movement.when.add(const Duration(seconds: 40)),);

    await mongoService.db
        .collection('movements')
        .replaceOne(where.id(movement.id!), movement.toMap());
    
    return plunder;
  }

  List<int> _calculatePlunder(List<int> units, Settlement settlement) {
    final storage = settlement.storage;
    final availableResources = storage.fold(0.0, (sum, value) => sum + value);
    final resPercents = storage
        .map((res) => ((100 * res) / availableResources).round())
        .toList();
    final carry = min(_calculateCarry(units), availableResources);

    final wood = ((resPercents[0] / 100) * carry).round();
    final clay = ((resPercents[1] / 100) * carry).round();
    final iron = ((resPercents[2] / 100) * carry).round();
    final crop = ((resPercents[3] / 100) * carry).round();

    return [wood, clay, iron, crop];
  }

  int _calculateCarry(List<int> units) {
    final template = UnitsConst.UNITS[2];
    var carry = 0;
    for (var i = 0; i < units.length; i++) {
      carry += units[i] * template[i].capacity;
    }
    return carry;
  }

  void _subtractStolenResources(List<int> plunder, Settlement def) {
    final storage = def.storage;
    for (var i = 0; i < 4; i++) {
      var res = storage[i];
      res -= plunder[i];
      storage[i] = res;
    }
  }
}
