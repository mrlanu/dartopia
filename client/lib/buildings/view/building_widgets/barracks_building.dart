import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';

import '../../../village/bloc/village_bloc.dart';
import '../widgets/building_card.dart';

class BarracksBuilding extends StatelessWidget {
  const BarracksBuilding({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VillageBloc, VillageState>(
      builder: (context, state) {
        return Center(
            child: BuildingCard(
                specification: buildingSpecefication[BuildingId.BARRACKS]!,
                storage: state.settlement!.storage,
                buildingList: state.buildingViewModelList));
      },
    );
  }
}
