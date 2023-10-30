import 'dart:core';
import 'dart:math';

enum BuildingId {
  WOODCUTTER, CLAY_PIT, IRON_MINE, CROPLAND, RALLY_POINT, MAIN, GRANARY, WAREHOUSE, BARRACK, MARKETPLACE, ACADEMY,
  BLACKSMITH, EMPTY
  /*WOODCUTTER, CLAY_PIT, IRON_MINE, CROPLAND, SAWMILL, BRICKYARD, IRON_FOUNDRY, GRAIN_MILL, BAKERY, WAREHOUSE, GRANARY,
    ARMORY, BLACKSMITH, ARENA, MAIN, RALLY_POINT, MARKETPLACE, EMBASSY, BARRACK, STABLES, WORKSHOP,
    ACADEMY, CRANNY, TOWN_HALL, RESIDENCE, PALACE, TRADE_OFFICE, GREAT_BARRACKS, GREAT_STABLES, CITY_WALL, EARTH_WALL,
    PALISADE, EMPTY*/
}

class Building {
  final BuildingId id;
  final String name;
  final List<int> cost;
  final Time time;
  final int Function(int val) benefit;
  final double k;
  final int upkeep;
  final int culture;
  final int maxLevel;
  final String description;
  final List<RequirementBuilding> requirementBuildings;
  final bool isMulti;


  Building(
      {required this.id,
        required this.name,
        required this.cost,
        required this.time,
        required this.benefit,
        required this.k,
        required this.upkeep,
        required this.culture,
        this.maxLevel = 10,
        this.description = '',
        this.requirementBuildings = const [],
        this.isMulti = false,});

  int getPopulation(int level) {
    return level == 1 ? upkeep : ((5 * upkeep + level - 1) / 10.0).round();
  }

  int getCapacity(int level) {
    final number = pow(1.2, level) * 2120 - 1320;
    return (number / 100).round() * 100;
  }

  List<int> getResourcesToNextLevel(int level) {
    return [
      _round((pow(k, level - 1) * cost[0]) as double, 5),
      _round((pow(k, level - 1) * cost[1]) as double, 5),
      _round((pow(k, level - 1) * cost[2]) as double, 5),
      _round((pow(k, level - 1) * cost[3]) as double, 5)
    ];
  }

  int _round(double v, double n) {
    return ((v / n) * n).round();
  }
}

class Time {
  final double a;
  final double k;
  final double b;

  Time(this.a, this.k, this.b);

  Time.withA(this.a)
      : k = 1.16,
        b = 1875;

  int valueOf(int lvl){
    double prev = this.a * pow(this.k, lvl-1) - this.b;
    return prev.toInt();
  }
}

class RequirementBuilding {
  final BuildingId id;
  final int level;

  RequirementBuilding({required this.id, required this.level});
}

final buildingSpecefication = <Building>[
  Building(id: BuildingId.WOODCUTTER, name: 'Wood cutter',
    cost: [40, 100, 50, 60], time: Time(1780/3, 1.6, 1000/3),
    benefit: getProduction, k: 1.67, upkeep: 2, culture: 1,),
  Building(id: BuildingId.CLAY_PIT, name: "Clay pit",
      cost: [80, 40, 80, 50], time :Time(1660/3, 1.6, 1000/3),
      benefit: getProduction, k:1.67, upkeep: 2, culture:1,),
  Building(id: BuildingId.IRON_MINE, name: "Iron mine",
    cost: [100, 80, 30, 60], time :Time(2350/3, 1.6, 1000/3),
    benefit: getProduction, k:1.67, upkeep: 2, culture:1,),
  Building(id: BuildingId.CROPLAND, name: "Cropland",
    cost: [70, 90, 70, 20], time :Time(1450/3, 1.6, 1000/3),
    benefit: getProduction, k:1.67, upkeep: 0, culture:1,)
];

final productions = [
2, 5, 9, 15, 22, 33, 50, 70, 100, 145, 200,
280, 375, 495, 635, 800, 1000, 1300, 1600,
2000, 2450, 3050,];

int getProduction(int level){
  return productions[level];
}
