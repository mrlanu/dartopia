import 'package:dartopia/consts/calors.dart';
import 'package:flutter/material.dart';

import '../../buildings/view/building_widgets/building_widgets_factory.dart';

class BuildingDetailPage extends StatelessWidget {
  const BuildingDetailPage(
      {super.key, required this.buildingRecord});

  final List<int> buildingRecord;

  @override
  Widget build(BuildContext context) {
    return BuildingDetailView(buildingRecord: buildingRecord);
  }
}

class BuildingDetailView extends StatelessWidget {
  const BuildingDetailView({super.key, required this.buildingRecord});

  final List<int> buildingRecord;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: DartopiaColors.background,
          appBar: AppBar(),
          body: BuildingWidgetsFactory.get(buildingRecord)),
    );
  }
}
