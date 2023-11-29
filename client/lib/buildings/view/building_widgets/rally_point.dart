import 'package:dartopia/rally_point/rally_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../view.dart';

class RallyPoint extends StatelessWidget {
  const RallyPoint({super.key, required this.buildingRecord});

  final List<int> buildingRecord;

  @override
  Widget build(BuildContext context) {
    return BuildingContainer(
      key: ValueKey('${buildingRecord[1]} ${buildingRecord[0]}'),
      buildingRecord: buildingRecord,
      enterable: true,
      onEnter: () => Navigator.of(context).push(RallyPointPage.route(
          buildingRecord: buildingRecord,
          movementsBloc: context.read<MovementsBloc>())),
      child: (settlement, buildingRecord) {
        return const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Rally Point'),
          ],
        );
      },
    );
  }
}
