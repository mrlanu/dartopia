import 'dart:math';
import 'package:models/models.dart';

import 'battle.dart';

enum ESide { OFF, DEF }

class Army {
  Army({
    required this.side,
    required this.population,
    required this.units,
    required this.numbers,
    this.party = false,
    this.brew = false,
    this.upgrades = const [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    this.mission = Mission.raid,
    this.targets = const [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  });

  final ESide side;
  final int population;
  final List<Unit> units;
  List<int> numbers;
  final List<int> upgrades;
  final Mission mission;
  final List<int> targets;
  final bool party;
  final bool brew;

  bool isScan() {
    var scanPosition = 0;
    for (var i = 0; i < units.length; i++) {
      if (units[i].unitKind == UnitKind.SPY) {
        scanPosition = i;
        break;
      }
    }
    return numbers[scanPosition] > 0;
  }

  BattlePoints getOff() {
    final result = zipWith(
      (unit, number, upgrade) {
        final points = number * upgradeMethod(unit.offense, upgrade);
        return BattlePoints.off(points, unit.infantry);
      },
      units,
      numbers,
      upgrades,
    );
    return result.fold(BattlePoints.zero(), (acc, val) => acc.add(val));
  }

  BattlePoints getDef() {
    final result = zipWith(
      (unit, number, upgrade) {
        final infantryPoints = upgradeMethod(unit.defenseInfantry, upgrade);
        final cavalryPoints = upgradeMethod(unit.defenseCavalry, upgrade);
        return BattlePoints(infantryPoints, cavalryPoints).mul(number);
      },
      units,
      numbers,
      upgrades,
    );
    return result.fold(BattlePoints.zero(), (acc, val) => acc.add(val));
  }

  double getScan() {
    final result = zipWith(
      (unit, number, upgrade) {
        return unit.unitKind == UnitKind.SPY
            ? number * upgradeMethod(unit.getS(), upgrade)
            : 0;
      },
      units,
      numbers,
      upgrades,
    );
    return result.fold(0, (acc, val) => acc + val);
  }

  double getScanDef() {
    final result = zipWith(
      (unit, number, upgrade) {
        return unit.unitKind == UnitKind.SPY
            ? number * upgradeMethod(unit.getSD(), upgrade)
            : 0;
      },
      units,
      numbers,
      upgrades,
    );
    return result.fold(0, (acc, val) => acc + val);
  }

  int getTotal() {
    return numbers.fold(0, (acc, val) => acc + val);
  }

  double upgradeMethod(int stat, int level) {
    final number = pow(1.015, level) * stat;
    return (1e-4 * number / 1e-4).round().toDouble();
  }

  static List<R> zipWith<A, B, C, R>(
    R Function(A, B, C) f,
    List<A> units,
    List<B> numbers,
    List<C> upgrades,
  ) {
    final result = <R>[];
    for (var i = 0; i < units.length; i++) {
      result.add(f(units[i], numbers[i], upgrades[i]));
    }
    return result;
  }

  void applyLosses(double losses, BattleResult battleResult) {
    final unitsBefore = <int>[];
    final casualties = <int>[];
    numbers = numbers.map((n) {
      unitsBefore.add(n);
      final after = (n * (1 - losses)).round();
      casualties.add(n - after);
      return after;
    }).toList();
    battleResult.unitsBeforeBattle?.add(unitsBefore);
    battleResult.casualties?.add(casualties);
  }

  List<int> rams() {
    for (var i = 0; i < 10; i++) {
      if (units[i].unitKind == UnitKind.RAM) {
        return [numbers[i], upgrades[i]];
      }
    }
    return [0, 0];
  }

  List<int> cats() {
    for (var i = 0; i < 10; i++) {
      if (units[i].unitKind == UnitKind.CAT) {
        return [numbers[i], upgrades[i]];
      }
    }
    return [0, 0];
  }
}

