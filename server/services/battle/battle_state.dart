import 'battle.dart';

class BattleState {

  BattleState({
    required this.base,
    required this.finale,
    required this.wall,
    required this.immensity,
    required this.ratio,
  });

  BattleState.defaultValues()
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
