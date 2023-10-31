import 'package:flutter/cupertino.dart';

import '../view/building_widgets/barracks_building.dart';
import '../view/building_widgets/emty.dart';
import '../view/building_widgets/main_building.dart';
import 'building_model.dart';

enum BuildingId {
  MAIN,
  BARRACKS,
  EMPTY,
  ACADEMY,
  BAKERY,
  CRANNY,
  EMBASSY,
  GRAIN_MILL,
  GRANARY,
  MARKETPLACE,
  RALLY_POINT,
  WAREHOUSE,
}

Map<BuildingId, BuildingModel> buildingsMap = {
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
};
