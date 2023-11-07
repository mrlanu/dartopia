import 'package:flutter/cupertino.dart';

import '../view.dart';

Map<int, Widget> buildingWidgetsMap = {
  0: const Lumber(key: ValueKey(0)),
  1: const ClayPit(key: ValueKey(1)),
  2: const IronMine(key: ValueKey(2)),
  3: const Cropland(key: ValueKey(3)),
  4: const MainBuilding(key: ValueKey(4)),
  5: const SizedBox(height: 100, width: 100, key: ValueKey(5)),
  6: const SizedBox(height: 100, width: 100, key: ValueKey(6)),
  7: const BarracksBuilding(key: ValueKey(7)),
  8: const SizedBox(height: 100, width: 100, key: ValueKey(8)),
  /*9: const SizedBox(height: 100, width: 100, key: ValueKey(BuildingId.ACADEMY)),
  10: const SizedBox(height: 100, width: 100, key: ValueKey(BuildingId.BAKERY)),
  11: const SizedBox(height: 100, width: 100, key: ValueKey(BuildingId.CRANNY),),
  12: const SizedBox(height: 100, width: 100, key: ValueKey(BuildingId.EMBASSY)),
  13: const SizedBox(height: 100, width: 100, key: ValueKey(BuildingId.GRAIN_MILL)),
  14: const SizedBox(height: 100, width: 100, key: ValueKey(BuildingId.MARKETPLACE)),*/

  // SHOULD BE LAST ONE
  99: const Empty(key: ValueKey('HUY')),
};

/*Map<BuildingId, Widget Function(Key key)> buildingWidgetsMap = {
  BuildingId.LUMBER: (key) => Lumber(key: key),
  BuildingId.CLAY_PIT: (key) => ClayPit(key: key),
  BuildingId.IRON_MINE: (key) => IronMine(key: key),
  BuildingId.CROPLAND: (key) => Cropland(key: key),
  BuildingId.MAIN: (key) => MainBuilding(key: key),
  BuildingId.ACADEMY: (key) => SizedBox(height: 100, width: 100, key: key,),
  BuildingId.BAKERY: (key) => SizedBox(height: 100, width: 100, key: key,),
  BuildingId.BARRACKS: (key) => BarracksBuilding(key: key),
  BuildingId.CRANNY: (key) => SizedBox(height: 100, width: 100, key: key,),
  BuildingId.EMBASSY: (key) => SizedBox(height: 100, width: 100, key: key,),
  BuildingId.GRAIN_MILL: (key) => SizedBox(height: 100, width: 100, key: key,),
  BuildingId.GRANARY: (key) => SizedBox(height: 100, width: 100, key: key,),
  BuildingId.MARKETPLACE: (key) => SizedBox(height: 100, width: 100, key: key,),
  BuildingId.RALLY_POINT: (key) => BarracksBuilding(key: key),
  BuildingId.WAREHOUSE: (key) => BarracksBuilding(key: key),
  // SHOULD BE LAST ONE
  BuildingId.EMPTY: (key) => Empty(key: key),
};*/
