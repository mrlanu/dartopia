import 'package:flutter/cupertino.dart';
import 'package:models/models.dart';

import '../view.dart';

Map<BuildingId, Widget> buildingWidgetsMap = {
  BuildingId.LUMBER: const Lumber(key: ValueKey(BuildingId.LUMBER)),
  BuildingId.CLAY_PIT: const ClayPit(key: ValueKey(BuildingId.CLAY_PIT)),
  BuildingId.IRON_MINE: const IronMine(key: ValueKey(BuildingId.IRON_MINE)),
  BuildingId.CROPLAND: const Cropland(key: ValueKey(BuildingId.CROPLAND)),
  BuildingId.MAIN: const MainBuilding(key: ValueKey(BuildingId.MAIN)),
  BuildingId.ACADEMY: const SizedBox(height: 100, width: 100, key: ValueKey(BuildingId.ACADEMY)),
  BuildingId.BAKERY: const SizedBox(height: 100, width: 100, key: ValueKey(BuildingId.BAKERY)),
  BuildingId.BARRACKS: const BarracksBuilding(key: ValueKey(BuildingId.BARRACKS)),
  BuildingId.CRANNY: const SizedBox(height: 100, width: 100, key: ValueKey(BuildingId.CRANNY),),
  BuildingId.EMBASSY: const SizedBox(height: 100, width: 100, key: ValueKey(BuildingId.EMBASSY)),
  BuildingId.GRAIN_MILL: const SizedBox(height: 100, width: 100, key: ValueKey(BuildingId.GRAIN_MILL)),
  BuildingId.GRANARY: const SizedBox(height: 100, width: 100, key: ValueKey(BuildingId.GRANARY)),
  BuildingId.MARKETPLACE: const SizedBox(height: 100, width: 100, key: ValueKey(BuildingId.MARKETPLACE)),
  BuildingId.RALLY_POINT: const SizedBox(height: 100, width: 100, key: ValueKey(BuildingId.RALLY_POINT)),
  BuildingId.WAREHOUSE: const SizedBox(height: 100, width: 100, key: ValueKey(BuildingId.WAREHOUSE)),
  // SHOULD BE LAST ONE
  BuildingId.EMPTY: const Empty(key: ValueKey('HUY')),
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
