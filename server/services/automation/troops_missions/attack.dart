import 'dart:math';

import 'package:models/models.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../../battle/battle.dart';
import '../../battle/main_battle.dart';
import '../../utils_service.dart';
import 'troop_missions.dart';

class Attack extends MissionStrategy {
  Attack({
    required super.movement,
    required super.mongoService,
    required super.settlementService,
  });

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

    final reinforcements = await settlementService
        .getAllStaticForeignMovementsBySettlementId(defenseSettlement.id.$oid);

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
      numbers: defenseSettlement.units,
    );
    final reinforcementArmies = reinforcements
        .map(
          (m) => Army(
            side: ESide.DEF,
            population: 100,
            units: UnitsConst.UNITS[2],
            numbers: m.units,
          ),
        )
        .toList();

    final sidesArmy = [ownDef, ...reinforcementArmies, off];

    final battleResults = battle.perform(battleField, sidesArmy);
    final plunder = await _returnOff(
      sidesArmy[sidesArmy.length - 1],
      offenseSettlement,
      defenseSettlement,
    );
    sidesArmy.removeAt(sidesArmy.length - 1);
    await _updateDef(defenseSettlement, sidesArmy, reinforcements);
    await settlementService.updateSettlement(settlement: defenseSettlement);
    await _createReports(
      attacker: offenseSettlement,
      defender: defenseSettlement,
      reinforcement: reinforcements,
      battleResult: battleResults[0],
      plunder: plunder,
    );
  }

  Future<void> _updateDef(
    Settlement def,
    List<Army> sidesArmy,
    List<Movement> defEntities,
  ) async {
    def.units = sidesArmy[0].numbers;
    // start from 1 because there is own army on the front in sidesArmy
    for (var i = 1; i < sidesArmy.length; i++) {
      var currentDef = defEntities[i - 1];
      if (sidesArmy[i].numbers.reduce((a, b) => a + b) == 0) {
        await mongoService.db!
            .collection('movements')
            .deleteOne(where.id(currentDef.id!));
        continue;
      }
      currentDef = currentDef.copyWith(units: sidesArmy[i].numbers);
      await mongoService.db!
          .collection('movements')
          .replaceOne(where.id(currentDef.id!), currentDef.toMap());
    }
  }

  Future<List<int>> _returnOff(
    Army offArmy,
    Settlement off,
    Settlement def,
  ) async {
    //off has been completely destroyed
    if (offArmy.numbers.reduce((value, element) => value + element) == 0) {
      await mongoService.db!
          .collection('movements')
          .deleteOne(where.id(movement.id!));
      return [0, 0, 0, 0];
    }
    final plunder = _calculatePlunder(offArmy.numbers, def);
    _subtractStolenResources(plunder, def);
    final backMovement = movement.copyWith(
      from: movement.to,
      to: movement.from,
      units: offArmy.numbers,
      plunder: plunder,
      mission: Mission.back,
      when: UtilsService.getArrivalTime(
        toX: off.x,
        toY: off.y,
        fromX: def.x,
        fromY: def.y,
        units: offArmy.numbers,
      ),
    );

    await mongoService.db!
        .collection('movements')
        .replaceOne(where.id(backMovement.id!), backMovement.toMap());

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
      if (res < 0) res = 0;
      storage[i] = res;
    }
  }

  Future<void> _createReports({
    required Settlement attacker,
    required Settlement defender,
    required List<Movement> reinforcement,
    required BattleResult battleResult,
    required List<int> plunder,
  }) async {
    final ownDef = PlayerInfo(
      settlementId: defender.id.$oid,
      settlementName: defender.name,
      playerName: movement.to.playerName,
      nation: defender.nation,
      units: battleResult.unitsBeforeBattle![0],
      casualty: battleResult.casualties![0],
    );

    final off = PlayerInfo(
      settlementId: movement.from.villageId,
      settlementName: movement.from.villageName,
      playerName: movement.from.playerName,
      nation: movement.nation,
      units: battleResult
          .unitsBeforeBattle![battleResult.unitsBeforeBattle!.length - 1],
      casualty: battleResult.casualties![battleResult.casualties!.length - 1],
    );

    final participants = [
      off,
      ownDef,
    ];

    for (var i = 0; i < reinforcement.length; i++) {
      final current = reinforcement[i];
      participants.add(
        PlayerInfo(
          settlementId: current.from.villageId,
          settlementName: current.from.villageName,
          playerName: current.from.playerName,
          nation: current.nation,
          units: battleResult.unitsBeforeBattle![i + 1],
          casualty: battleResult.casualties![i + 1],
        ),
      );
    }

    final reportOwners = [
      ReportOwner(playerId: attacker.userId),
      if (defender.kind.isNotOasis)
        ReportOwner(playerId: defender.userId),
      ...reinforcement.map(
        (e) => ReportOwner(playerId: e.from.userId),
      ),
    ];

    final report = ReportEntity(
      id: ObjectId().$oid,
      reportOwners: reportOwners,
      mission: movement.mission,
      participants: participants,
      dateTime: movement.when,
      bounty: plunder,
    );

    await mongoService.db!.collection('reports').insertOne(report.toMap());
  }
}
