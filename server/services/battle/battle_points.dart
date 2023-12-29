class BattlePoints {
  const BattlePoints(this.i, this.c);

  factory BattlePoints.off(double value, bool isInfantry) {
    return isInfantry ? BattlePoints(value, 0) : BattlePoints(0, value);
  }

  BattlePoints.zero()
      : i = 0,
        c = 0;

  final double i;
  final double c;

  static BattlePoints sum(BattlePoints a, BattlePoints b) {
    return a.add(b);
  }

  BattlePoints add(BattlePoints that) {
    return BattlePoints(i + that.i, c + that.c);
  }

  BattlePoints mul(int m) {
    return BattlePoints(i * m, c * m);
  }
}
