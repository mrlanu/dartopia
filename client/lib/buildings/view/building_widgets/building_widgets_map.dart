import 'package:flutter/cupertino.dart';

import '../view.dart';

Map<int, Widget Function(int position)> buildingWidgetsMap = {
  0: (position) => Field(key: ValueKey('0 $position'), position: position),
  1: (position) => Field(key: ValueKey('1 $position'), position: position),
  2: (position) => Field(key: ValueKey('2 $position'), position: position),
  3: (position) => Field(key: ValueKey('3 $position'), position: position),
  4: (position) => MainBuilding(key: ValueKey('4 $position')),
  5: (position) => SizedBox(height: 100, width: 100, key: ValueKey('5 $position')),
  6: (position) => SizedBox(height: 100, width: 100, key: ValueKey('6 $position')),
  7: (position) => BarracksBuilding(key: ValueKey('7 $position')),
  8: (position) => SizedBox(height: 100, width: 100, key: ValueKey('8 $position')),
  /*9: const SizedBox(height: 100, width: 100, key: ValueKey(BuildingId.ACADEMY)),
  10: const SizedBox(height: 100, width: 100, key: ValueKey(BuildingId.BAKERY)),
  11: const SizedBox(height: 100, width: 100, key: ValueKey(BuildingId.CRANNY),),
  12: const SizedBox(height: 100, width: 100, key: ValueKey(BuildingId.EMBASSY)),
  13: const SizedBox(height: 100, width: 100, key: ValueKey(BuildingId.GRAIN_MILL)),
  14: const SizedBox(height: 100, width: 100, key: ValueKey(BuildingId.MARKETPLACE)),*/

  // SHOULD BE LAST ONE
  99: (position) => Empty(key: ValueKey('99 $position'), position: position),
  100: (position) => SizedBox(height: 100, width: 100, key: ValueKey('100 $position')),
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
