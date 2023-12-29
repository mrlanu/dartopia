import 'battle.dart';

class BattleState {
  BattleState()
      : base = BattleSides<double>(0, 0),
        finale = BattleSides<double>(0, 0),
        wall = 0,
        immensity = 0.0,
        ratio = 0;
  BattleSides<double> base;
  final BattleSides<double> finale;
  int wall;
  double immensity;
  final int ratio;

  double getRatio() {
    return finale.off / finale.def;
  }
}
