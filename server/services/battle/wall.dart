import 'dart:math';

import 'battle.dart';

class Wall {

  const Wall(this.level, this.durability);
  final int level;
  final int durability;

  WallBonus<double> getBonus(int lvl, double base) {
    final defBonus = Fns.roundP(0.001, pow(base, lvl).toDouble()) - 1.0;
    return WallBonus.off(defBonus, 0);
  }
}
