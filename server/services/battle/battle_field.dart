import 'battle.dart';

class BattleField {
  const BattleField({
    required this.tribe,
    required this.population,
    this.def = 0,
    this.party = false,
    this.durBonus = 1,
    this.wall = const Wall(0, 1),
  });

  final int tribe;
  final int population;
  final int durBonus;
  final Wall wall;
  final int def;
  final bool party;
}
