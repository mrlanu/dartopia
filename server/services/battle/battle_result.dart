class BattleResult {

  BattleResult({
    this.offLoses = 0,
    this.defLosses = 0,
    this.buildings,
    this.wall = 0,
    this.unitsBeforeBattle,
    this.casualties,
  });

  factory BattleResult.simple(double offLoses, double defLosses, int wall) {
    return BattleResult(
      offLoses: offLoses,
      defLosses: defLosses,
      buildings: <int>[],
      wall: wall,
      unitsBeforeBattle: <List<int>>[],
      casualties: <List<int>>[],
    );
  }
  double offLoses;
  double defLosses;
  List<int>? buildings;
  int wall;
  List<List<int>>? unitsBeforeBattle;
  List<List<int>>? casualties;
}
