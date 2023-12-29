import 'dart:math';
import 'battle.dart';

class Fns {
  Fns(): earlyRamTable = [] {
    generateTable();
  }

  final List<List<double>> earlyRamTable;

  void generateTable() {
    for (var lvl = 0; lvl <= 20; lvl++) {
      final row = <double>[];
      int l;
      for (l = 0; l <= lvl ~/ 2; l++) {
        row.add(-2 * l * l + (2 * lvl + 1) * l.toDouble());
      }
      final base = lvl * (lvl + 1) ~/ 2 + 20;
      for (; l <= lvl; l++) {
        final dl = l - (lvl / 2).floor() - 1;
        row.add(1.25 * dl * dl + 49.75 * dl + base.toDouble());
      }
      row.add(1000000000);
      earlyRamTable.add(row);
    }
  }

  BattleSides<double> adducedDef(BattlePoints off, BattlePoints def) {
    final totalOff = off.i + off.c;
    final infantryPart = roundPercent(off.i / totalOff);
    final cavalryPart = roundPercent(off.c / totalOff);
    final totalDef = def.i * infantryPart + def.c * cavalryPart;
    return BattleSides.off(totalOff, totalDef);
  }

  double roundPercent(double number) {
    return roundP(1e-4, number);
  }

  double immensity(int total) {
    return 1.5;
  }

  double morale(int offPop, int defPop, double ptsRatio) {
    if (offPop <= defPop) {
      return 1;
    }
    final popRatio = offPop / (defPop.clamp(3, double.infinity));
    return popRatio.isNaN
        ? 1
        : popRatio.isInfinite
            ? 0
            : popRatio.isFinite
                ? 0.667
                : roundP(
                    1e-3, pow(popRatio, -0.2 * min(ptsRatio, 1)).toDouble(),);
  }

  static double roundP(double precision, double number) {
    return precision * (number / precision).round();
  }

  BattleSides<double> raid(double x) {
    return BattleSides.off(1 / (1 + x), x / (1 + x));
  }

  double demolishPoints(
      int catas, int upgLvl, int durability, double ptsRatio, double morale) {
    final offCatas = (catas / durability).floorToDouble() * morale;
    return 4 * sigma(ptsRatio) * offCatas * siegeUpgrade(upgLvl);
  }

  double sigma(double x) {
    return (x > 1 ? 2 - pow(x, -1.5) : pow(x, 1.5)) / 2;
  }

  double siegeUpgrade(int level) {
    return roundP(0.005, pow(1.0205, level).toDouble());
  }

  double demolishWall(int tribeDur, int level, double points) {
    final row = earlyRamTable[level];
    var dem = 0;
    while ((tribeDur * row[dem + 1]).floor() <= points) {
      dem++;
    }
    return level - dem.toDouble();
  }

  int demolish(int initialLevel, double initialDamage) {
    var damage = initialDamage - 0.5;
    var level = initialLevel;

    if (damage < 0) {
      return level;
    }

    while (damage >= level && level > 0) {
      damage -= level.toDouble();
      level--;
    }

    return level;
  }

  double cataMorale(int offPopulation, int defPopulation) {
    return 1;
  }
}
