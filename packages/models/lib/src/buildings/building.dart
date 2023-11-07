import 'dart:core';
import 'dart:math';

class Building {
  final int id;
  final String name;
  final List<int> cost;
  final Time time;
  final double Function(int val) benefit;
  final double k;
  final int upkeep;
  final int culture;
  final int maxLevel;
  final String description;
  final List<List<int>> requirementBuildings;
  final bool isMulti;
  final String imagePath;

  Building({
    required this.id,
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
    this.isMulti = false,
    this.imagePath = '',
  });

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

  int valueOf(int lvl) {
    double prev = this.a * pow(this.k, lvl - 1) - this.b;
    return prev.toInt();
  }
}

final buildingSpecefication = <int, Building>{
  0: Building(
    id: 0,
    name: 'Wood cutter',
    cost: [40, 100, 50, 60],
    time: Time(1780 / 3, 1.6, 1000 / 3),
    benefit: getProduction,
    k: 1.67,
    upkeep: 2,
    culture: 1,
    imagePath: 'assets/images/buildings/wood.png',
  ),
  1: Building(
    id: 1,
    name: 'Clay pit',
    cost: [80, 40, 80, 50],
    time: Time(1660 / 3, 1.6, 1000 / 3),
    benefit: getProduction,
    k: 1.67,
    upkeep: 2,
    culture: 1,
    imagePath: 'assets/images/buildings/clay_2.png',
  ),
  2: Building(
    id: 2,
    name: 'Iron mine',
    cost: [100, 80, 30, 60],
    time: Time(2350 / 3, 1.6, 1000 / 3),
    benefit: getProduction,
    k: 1.67,
    upkeep: 2,
    culture: 1,
    imagePath: 'assets/images/buildings/iron_2.png',
  ),
  3: Building(
    id: 3,
    name: 'Crop land',
    cost: [70, 90, 70, 20],
    time: Time(1450 / 3, 1.6, 1000 / 3),
    benefit: getProduction,
    k: 1.67,
    upkeep: 0,
    culture: 1,
    imagePath: 'assets/images/buildings/crop_2.png',
  ),
  4: Building(
      id: 4,
      name: 'Main',
      cost: [70, 40, 60, 20],
      time: Time.withA(3875),
      benefit: mbLike,
      k: 1.28,
      upkeep: 2,
      culture: 2,
      description:
      'The main building of the village builders live. higher level of the main building , the faster under construction.',
      imagePath: 'assets/images/buildings/main.png',),
  5: Building(
      id: 5,
      name: 'Granary',
      cost: [80, 100, 70, 20],
      time: Time.withA(3475),
      benefit: getCapacity,
      k: 1.28,
      upkeep: 1,
      culture: 1,
      description:
      'Crop produced by your croplands is stored in the granary. By increasing its level, you increase the granarys capacity.',
      imagePath: 'assets/images/buildings/granary.png',
      requirementBuildings: [[5, 1]],),
  6: Building(
      id: 6,
      name: 'Warehouse',
      cost: [130, 160,  90,  40],
      time: Time.withA(3875),
      benefit: getCapacity,
      k: 1.28,
      upkeep: 1,
      culture: 1,
      description:
      'The resources wood, clay and iron are stored in your warehouse. By increasing its level you increase your warehouses capacity.',
      imagePath: 'assets/images/buildings/warehouse.png',
      requirementBuildings: [[5,1]],),
  7: Building(
      id: 7,
      name: 'Barracks',
      cost: [210, 140, 260, 120],
      time: Time.withA(3875),
      benefit: train,
      k: 1.28,
      upkeep: 4,
      culture: 1,
      description:
      'In the barracks infantry can be trained troops . With the development of the barracks reduced training time soldiers.',
      imagePath: 'assets/images/buildings/barracks_v.png',
      requirementBuildings: [[5, 3], [16, 1],],),
  8: Building(
      id: 8,
      name: 'Rally point',
      cost: [110, 160, 90, 70],
      time: Time.withA(3875),
      benefit: speedBuild,
      description:
      'In the collection point of your soldiers are going to the village. From here you can send reinforcements to organize a raid or conquer.',
      k: 1.28,
      upkeep: 1,
      culture: 1,
      imagePath: 'assets/images/buildings/rally_point.png',),
  // SHOULD BE LAST ONE
  99: Building(
      id: 99,
      name: 'Empty',
      cost: [0, 0, 0, 0],
      time: Time(1450 / 3, 1.6, 1000 / 3),
      benefit: (val) => 1,
      imagePath: 'assets/images/buildings/empty.png',
      k: 0,
      upkeep: 0,
      culture: 0,),
};

/*Map<BuildingId, BuildingModel> buildingsMap = {
  BuildingId.MAIN: BuildingModel(
      id: BuildingId.MAIN,
      name: 'Main',
      description:
      'The main building of the village builders live. higher level of the main building , the faster under construction.',
      imagePath: 'assets/images/buildings/main.png',
      k: 1.28,
      cost: [70, 40, 60, 20],
      widget: const MainBuilding(key: ValueKey(BuildingId.MAIN))),
  BuildingId.ACADEMY: BuildingModel(
      id: BuildingId.ACADEMY,
      name: 'Academy',
      description:
      'The academy can be explored new types of troops. Academy With the development increases the amount available for the study of types of troops .',
      imagePath: 'assets/images/buildings/academy_v.png',
      k: 1.28,
      cost: [220, 160, 90, 40],
      buildingsReq: [(BuildingId.MAIN, 3), (BuildingId.BARRACKS, 3)]),
  BuildingId.BAKERY: BuildingModel(
      id: BuildingId.BAKERY,
      name: 'Bakery',
      description:
      'The bakery flour to bake bread . Grain production is associated with the level of development and bakeries can be increased , together with the mill , by 50 percent.',
      imagePath: 'assets/images/buildings/bakery.png',
      k: 1.8,
      cost: [1200, 1480, 870, 1600],
      buildingsReq: [(BuildingId.GRAIN_MILL, 5), (BuildingId.MAIN, 5)]),
  BuildingId.BARRACKS: BuildingModel(
      id: BuildingId.BARRACKS,
      name: 'Barracks',
      level: 3,
      description:
      'In the barracks infantry can be trained troops . With the development of the barracks reduced training time soldiers.',
      imagePath: 'assets/images/buildings/barracks_v.png',
      k: 1.28,
      cost: [210, 140, 260, 120],
      buildingsReq: [(BuildingId.MAIN, 3), (BuildingId.RALLY_POINT, 1)],
      widget: const BarracksBuilding(key: ValueKey(BuildingId.BARRACKS))),
  BuildingId.CRANNY: BuildingModel(
      id: BuildingId.CRANNY,
      name: 'Cranny',
      description:
      'If your raid on the village of its inhabitants hiding in the cache of the raw material from storage . These raw materials can not be stolen by the attackers .',
      imagePath: 'assets/images/buildings/cranny.png',
      k: 1.28,
      cost: [40, 50, 30, 10]),
  BuildingId.EMBASSY: BuildingModel(
      id: BuildingId.EMBASSY,
      name: 'Embassy',
      description:
      'The embassy is the place for diplomatic relations. At level 1 you can join an alliance, while with a level 3 embassy you may even found one yourself.',
      imagePath: 'assets/images/buildings/embassy.png',
      k: 1.28,
      cost: [180, 130, 150, 80],
      buildingsReq: [(BuildingId.MAIN, 1)]),
  BuildingId.GRAIN_MILL: BuildingModel(
      id: BuildingId.GRAIN_MILL,
      name: 'Grain mill',
      description:
      'On the flour mill grain into flour melyat . Grain production is associated with the level of development of the flour mill and may be increased by 25 percent.',
      imagePath: 'assets/images/buildings/grainmill.png',
      k: 1.8,
      cost: [500, 440, 380, 1240],
      buildingsReq: [(BuildingId.MAIN, 5)]),
  BuildingId.GRANARY: BuildingModel(
      id: BuildingId.GRANARY,
      name: 'Granary',
      description:
      'Crop produced by your croplands is stored in the granary. By increasing its level, you increase the granarys capacity.',
      imagePath: 'assets/images/buildings/granary.png',
      k: 1.28,
      cost: [80, 100, 70, 20],
      buildingsReq: [(BuildingId.MAIN, 1)]),
  BuildingId.MARKETPLACE: BuildingModel(
      id: BuildingId.MARKETPLACE,
      name: 'Marketplace',
      description:
      'The market can be shared with other players feed. As the market increases the number of available merchants.',
      imagePath: 'assets/images/buildings/marketplace.png',
      k: 1.28,
      cost: [80, 70, 120, 70],
      buildingsReq: [(BuildingId.MAIN, 3), (BuildingId.WAREHOUSE, 1), (BuildingId.GRANARY, 1)]),
  BuildingId.RALLY_POINT: BuildingModel(
      id: BuildingId.RALLY_POINT,
      name: 'Rally point',
      level: 1,
      description:
      'In the collection point of your soldiers are going to the village. From here you can send reinforcements to organize a raid or conquer.',
      imagePath: 'assets/images/buildings/rally_point.png',
      k: 1.28,
      cost: [110, 160,  90,  70],
      widget: const BarracksBuilding(key: ValueKey(BuildingId.BARRACKS))),
  BuildingId.WAREHOUSE: BuildingModel(
      id: BuildingId.WAREHOUSE,
      name: 'Warehouse',
      level: 1,
      description:
      'The resources wood, clay and iron are stored in your warehouse. By increasing its level you increase your warehouses capacity.',
      imagePath: 'assets/images/buildings/warehouse.png',
      k: 1.28,
      cost: [130, 160,  90,  40],
      buildingsReq: [(BuildingId.MAIN, 1)],
      widget: const BarracksBuilding(key: ValueKey(BuildingId.BARRACKS))),


  // SHOULD BE LAST ONE
  BuildingId.EMPTY: BuildingModel(
      id: BuildingId.EMPTY,
      name: 'Empty',
      description: '',
      imagePath: 'assets/images/buildings/empty.png',
      k: 0,
      cost: [],
      widget: const Empty(key: ValueKey(BuildingId.EMPTY))),
};*/

final productions = [
  2, 5, 9, 15, 22, 33, 50, 70, 100, 145, 200, 280, 375, 495, 635, //
  800, 1000, 1300, 1600, 2000, 2450, 3050,
];

double getCapacity(int level) {
  final number = pow(1.2, level) * 2120 - 1320;
  return 100.0 * (number / 100.0).round();
}

double getProduction(int level) {
  return productions[level].toDouble();
}

double train(int level){
  return pow(0.9, level - 1).toDouble();
}

double speedBuild(int level) {
  return level.toDouble();
}

double mbLike(int level){
  return pow(0.964, level - 1).toDouble();
}
