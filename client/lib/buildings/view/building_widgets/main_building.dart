import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';

import '../../../village/bloc/village_bloc.dart';
import '../widgets/building_card.dart';

class MainBuilding extends StatelessWidget {
  const MainBuilding({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VillageBloc, VillageState>(
      builder: (context, state) {
        return Center(
            child: BuildingCard(
          specification: buildingSpecefication[4]!,
          storage: state.settlement!.storage, buildingRecords: state.buildingRecords,
        ));
      },
    );
  }
}
