import 'dart:math';
import 'package:models/models.dart';

import 'battle.dart';

class Battle {
  Battle()
      : defArmies = [],
        battleState = BattleState(),
        battleResult = BattleResult(),
        fns = Fns();

  static const BASE_VILLAGE_DEF = 10;
  BattleField? battleField;
  Army? offArmy;
  List<Army> defArmies;
  BattleState battleState;
  BattleResult battleResult;
  Fns fns;

  List<BattleResult> perform(BattleField battleField, List<Army> sides) {
    this.battleField = battleField;
    final results = <BattleResult>[];
    for (final side in sides) {
      if (side.side == ESide.DEF) {
        defArmies.add(side);
      } else {
        offArmy = side;
        wave();
        for (final d in defArmies) {
          d.applyLosses(battleResult.defLosses, battleResult);
        }
        offArmy!.applyLosses(battleResult.offLoses, battleResult);
        results.add(battleResult);
      }
    }
    return results;
  }

  void wave() {
    battleResult = BattleResult.simple(0, 0, battleField!.wall.level);
    battleState.wall = battleField!.wall.level;
    if (offArmy!.isScan()) {
      scan();
    } else if (offArmy!.mission == Mission.raid) {
      raid();
    } else {
      normal();
    }
    loneAttackerDies();
  }

  void scan() {
    final offPoints = offArmy!.getScan() * morale(remorale: false);
    final defPoints =
        defArmies.fold(0, (a, b) => a + b.getScanDef().toInt()) * getDefBonus();
    final double losses = min(pow(defPoints / offPoints, 1.5).toDouble(), 1);
    battleResult
      ..offLoses = losses
      ..defLosses = 0.0;
  }

  void raid() {
    calcBasePoints();
    calcTotalPoints();
    final x = calcRatio();
    final pair = fns.raid(x);
    battleResult
      ..offLoses = pair.off
      ..defLosses = pair.def;
  }

  double calcRatio() {
    return pow(battleState.getRatio(), battleState.immensity).toDouble();
  }

  void normal() {
    calcBasePoints();
    calcTotalPoints();
    calcRams();
    final x = calcRatio();
    battleResult
      ..offLoses = min(1 / x, 1)
      ..defLosses = min(x, 1);
    calcCatapults();
  }

  void calcCatapults() {
    final targets = offArmy!.targets;
    if (targets.isEmpty) {
      return;
    }
    final morale = cataMorale();
    final cats = offArmy!.cats();
    final points = fns.demolishPoints(
      cats[0] ~/ targets.length,
      cats[1],
      battleField!.durBonus,
      battleState.ratio.toDouble(),
      morale,
    );
    battleResult.buildings =
        targets.map((b) => fns.demolish(b, points)).toList();
  }

  double cataMorale() {
    return fns.cataMorale(offArmy!.population, battleField!.population);
  }

  void calcRams() {
    final rams = offArmy!.rams();
    if (rams.isEmpty || battleState.wall == 0) {
      return;
    }
    final wall = battleField!.wall;
    final earlyPoints = fns.demolishPoints(
      rams[0],
      rams[1],
      battleField!.durBonus,
      battleState.ratio.toDouble(),
      1,
    );
    final demolishWall =
        fns.demolishWall(wall.durability, wall.level, earlyPoints);
    battleState.wall = demolishWall.toInt();
    calcTotalPoints();
    final points = fns.demolishPoints(
      rams[0],
      rams[1],
      battleField!.durBonus,
      battleState.ratio.toDouble(),
      1,
    );
    battleResult.wall = fns.demolish(wall.level, points);
  }

  void loneAttackerDies() {
    if (offArmy!.getTotal() == 1) {
      final offPair = offArmy!.getOff();
      final off = offPair.i + offPair.c;
      final mr = morale(remorale: false);
      if (off * mr < 84.5) {
        battleResult.offLoses = 1;
      }
    }
  }

  void calcBasePoints() {
    final offPts = offArmy!.getOff();
    final defPts = defArmies.map((a) => a.getDef()).reduce(BattlePoints.sum);
    battleState.base = fns.adducedDef(offPts, defPts);
    final total =
        defArmies.fold(offArmy!.getTotal(), (i, a) => i + a.getTotal());
    battleState.immensity = fns.immensity(total);
  }

  void calcTotalPoints() {
    calcDefBonuses();
    battleState.finale.off = battleState.base.off;
    final mr = morale(remorale: true);
    battleState.finale.off = battleState.base.off * mr;
  }

  double morale({required bool remorale}) {
    return fns.morale(
      offArmy!.population,
      battleField!.population,
      remorale ? (battleState.finale.off / battleState.finale.def) : 1.0,
    );
  }

  void calcDefBonuses() {
    final result = (battleState.base.def + getDefAbsolute()) * getDefBonus();
    battleState.finale.def = result;
  }

  double getDefBonus() {
    return 1 + battleField!.wall.getBonus(battleState.wall, 1.03).defBonus;
  }

  double getDefAbsolute() {
    return BASE_VILLAGE_DEF +
        battleField!.def +
        battleField!.wall.getBonus(battleState.wall, 1.03).def;
  }
}
