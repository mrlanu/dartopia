import 'package:flutter/cupertino.dart';
import 'package:models/models.dart';

import '../view/building_widgets/barracks_building.dart';
import '../view/building_widgets/emty.dart';
import '../view/building_widgets/main_building.dart';

Map<BuildingId, Widget> buildingWidgetsMap = {
  BuildingId.WOODCUTTER: const SizedBox(key: ValueKey(BuildingId.WOODCUTTER), height: 100, width: 100,),
  BuildingId.CLAY_PIT: const SizedBox(key: ValueKey(BuildingId.CLAY_PIT), height: 100, width: 100,),
  BuildingId.IRON_MINE: const SizedBox(key: ValueKey(BuildingId.IRON_MINE), height: 100, width: 100,),
  BuildingId.CROPLAND: const SizedBox(key: ValueKey(BuildingId.CROPLAND), height: 100, width: 100,),
  BuildingId.MAIN: const MainBuilding(key: ValueKey(BuildingId.MAIN)),
  BuildingId.ACADEMY: const SizedBox(height: 100, width: 100,),
  BuildingId.BAKERY: const SizedBox(height: 100, width: 100,),
  BuildingId.BARRACKS: const BarracksBuilding(key: ValueKey(BuildingId.BARRACKS)),
  BuildingId.CRANNY: const SizedBox(height: 100, width: 100,),
  BuildingId.EMBASSY: const SizedBox(height: 100, width: 100,),
  BuildingId.GRAIN_MILL: const SizedBox(height: 100, width: 100,),
  BuildingId.GRANARY: const SizedBox(height: 100, width: 100,),
  BuildingId.MARKETPLACE: const SizedBox(height: 100, width: 100,),
  BuildingId.RALLY_POINT: const BarracksBuilding(key: ValueKey(BuildingId.BARRACKS)),
  BuildingId.WAREHOUSE: const BarracksBuilding(key: ValueKey(BuildingId.BARRACKS)),
  // SHOULD BE LAST ONE
  BuildingId.EMPTY: const Empty(key: ValueKey(BuildingId.EMPTY)),
};
