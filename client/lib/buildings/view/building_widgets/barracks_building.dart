import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';

import '../../buildings.dart';
import '../widgets/building_card.dart';

class BarracksBuilding extends StatelessWidget {
  const BarracksBuilding({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BuildingsBloc, BuildingsState>(
      builder: (context, state) {
        return Center(
            child: BuildingCard(
                position: 1000,
                specification: buildingSpecefication[7]!,
                storage: state.settlement!.storage,
                buildingRecords: state.buildingRecords));
      },
    );
  }
}
