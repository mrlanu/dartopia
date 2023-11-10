import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';

import '../../buildings.dart';

class MainBuilding extends StatelessWidget {
  const MainBuilding({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BuildingsBloc, BuildingsState>(
      builder: (context, state) {
        return Center(
            child: BuildingCard(
          position: 1000, // SHOULD BE CHANGED OR DELETED
          specification: buildingSpecefication[4]!,
          storage: state.settlement!.storage,
          buildingRecords: state.buildingRecords,
        ));
      },
    );
  }
}
