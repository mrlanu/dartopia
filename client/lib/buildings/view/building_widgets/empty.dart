import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';

import '../../../settlement/settlement.dart';
import '../../buildings.dart';

class Empty extends StatefulWidget {
  const Empty({super.key, required this.buildingRecord});

  final List<int> buildingRecord;

  @override
  State<Empty> createState() => _EmptyState();
}

class _EmptyState extends State<Empty> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);
  }

  @override
  Widget build(BuildContext context) {
    final settlementState = context.read<SettlementBloc>().state;
    final allBuildingList =
        _getAvailableNewBuildings(settlementState.settlement!.buildings);
    return PageView.builder(
        controller: _pageController,
        onPageChanged: (value) {
          setState(() {
            //_currentPage = value % allBuildingList.length;
          });
        },
        itemBuilder: (context, index) {
          return Center(
              child: BuildingCard(
            position: widget.buildingRecord[0],
            specification: allBuildingList[index % allBuildingList.length],
            storage: settlementState.settlement!.storage,
            buildingRecords: settlementState.settlement!.buildings,
            constructionsTaskAmount:
                settlementState.settlement!.constructionTasks.length,
          ));
        });
  }

  List<Building> _getAvailableNewBuildings(
      List<List<int>> existBuildingRecords) {
    final result = buildingSpecefication.values
        .where((sp) =>
            sp.id != 0 &&
            sp.id != 1 &&
            sp.id != 2 &&
            sp.id != 3 &&
            sp.id != 99 &&
            sp.id != 100 &&
            (!_isBuildingExists(existBuildingRecords, sp.id) ||
                (_isBuildingExists(existBuildingRecords, sp.id) && sp.isMulti)))
        .toList();
    return result;
  }

  bool _isBuildingExists(List<List<int>> existBuildingRecords, int buildingId) {
    return existBuildingRecords.where((bR) => bR[1] == buildingId).isNotEmpty;
  }
}
