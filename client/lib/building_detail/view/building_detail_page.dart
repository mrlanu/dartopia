import 'package:dartopia/consts/calors.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

import '../../buildings/view/building_widgets/building_widgets_factory.dart';

class BuildingDetailPage extends StatelessWidget {
  const BuildingDetailPage({super.key, required this.buildingRecord});

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
    final specification = buildingSpecefication[buildingRecord[1]]!;
    return SafeArea(
      child: Scaffold(
          backgroundColor: DartopiaColors.background,
          appBar: AppBar(
              centerTitle: true,
              title: Text(
                '${specification.name} level ${buildingRecord[2]}',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: DartopiaColors.white),
              )),
          body: BuildingWidgetsFactory.get(buildingRecord)),
    );
  }
}
