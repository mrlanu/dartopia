import 'units.dart';

class Unit {

  const Unit({
    required this.unitKind,
    required this.name,
    required this.offense,
    required this.defenseInfantry,
    required this.defenseCavalry,
    required this.velocity,
    required this.cost,
    required this.upKeep,
    required this.time,
    required this.capacity,
    required this.infantry,
    required this.researchTime,
    required this.description,
  });
  final UnitKind unitKind;
  final String name;
  final int offense;
  final int defenseInfantry;
  final int defenseCavalry;
  final int velocity;
  final List<int> cost;
  final int upKeep;
  final int time;
  final int capacity;
  final bool infantry;
  final int researchTime;
  final String description;

  // For SPY units
  int getS() {
    return unitKind == UnitKind.SPY ? 35 : 0;
  }

  int getSD() {
    return unitKind == UnitKind.SPY ? 20 : 0;
  }
}
