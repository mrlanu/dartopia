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
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);
  }

  @override
  Widget build(BuildContext context) {
    final allBuildingList = buildingSpecefication.values
        .where((sp) =>
            sp.id != 0 && sp.id != 1 && sp.id != 2 && sp.id != 3 && sp.id != 99)
        .toList();
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (value) {
        setState(() {
          //_currentPage = value % allBuildingList.length;
        });
      },
      itemBuilder: (context, index) {
        return Center(child: BlocBuilder<SettlementBloc, SettlementState>(
          builder: (context, state) {
            return BuildingCard(
                position: widget.buildingRecord[0],
                specification: allBuildingList[index % allBuildingList.length],
                storage: state.settlement!.storage,
                buildingRecords: state.buildingRecords);
          },
        ));
      },
    );
  }
}
