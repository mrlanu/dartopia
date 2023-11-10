import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../buildings.dart';


class IronMine extends StatelessWidget {
  const IronMine({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BuildingsBloc, BuildingsState>(
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
