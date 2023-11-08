import 'package:dartopia/village/bloc/village_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';

import '../view.dart';


class IronMine extends StatelessWidget {
  const IronMine({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VillageBloc, VillageState>(
      builder: (context, state) {
        return Column(
          children: [
            ...state.settlement!.buildings
                .where((bR) => bR[1] == 2)
                .map((e) => FieldViewTile(buildingRecord: e))
                .toList()
          ],
        );
      },
    );
  }
}