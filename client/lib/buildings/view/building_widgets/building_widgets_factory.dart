import 'package:flutter/material.dart';

import '../view.dart';

class BuildingWidgetsFactory {
  BuildingWidgetsFactory._();

  static Widget get(List<int> buildingRecord) =>
      _buildingWidgetsMap[buildingRecord[1]]!(buildingRecord);

  static final Map<int, Widget Function(List<int> buildingRecord)>
      _buildingWidgetsMap = {
    0: (bR) => Field(key: _getUniqueKey(bR), buildingRecord: bR),
    1: (bR) => Field(key: _getUniqueKey(bR), buildingRecord: bR),
    2: (bR) => Field(key: _getUniqueKey(bR), buildingRecord: bR),
    3: (bR) => Field(key: _getUniqueKey(bR), buildingRecord: bR),
    4: (bR) => BuildingContainer(key: _getUniqueKey(bR), buildingRecord: bR),
    5: (bR) => Granary(key: _getUniqueKey(bR), buildingRecord: bR),
    6: (bR) => Warehouse(key: _getUniqueKey(bR), buildingRecord: bR),
    7: (bR) => BarracksBuilding(key: _getUniqueKey(bR), buildingRecord: bR,),
    8: (bR) => RallyPoint(key: _getUniqueKey(bR), buildingRecord: bR,),
    9: (bR) => Academy(key: _getUniqueKey(bR), buildingRecord: bR,),

    99: (bR) => Empty(key: _getUniqueKey(bR), buildingRecord: bR),
    100: (bR) => Construction(key: _getUniqueKey(bR), buildingRecord: bR),
    /*9: const SizedBox(height: 100, width: 100, key: ValueKey(BuildingId.ACADEMY)),
  10: const SizedBox(height: 100, width: 100, key: ValueKey(BuildingId.BAKERY)),
  11: const SizedBox(height: 100, width: 100, key: ValueKey(BuildingId.CRANNY),),
  12: const SizedBox(height: 100, width: 100, key: ValueKey(BuildingId.EMBASSY)),
  13: const SizedBox(height: 100, width: 100, key: ValueKey(BuildingId.GRAIN_MILL)),
  14: const SizedBox(height: 100, width: 100, key: ValueKey(BuildingId.MARKETPLACE)),*/
  };

  static ValueKey _getUniqueKey(List<int> bR) {
    return ValueKey('${bR[0]} ${bR[1]}');
  }
}
