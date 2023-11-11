import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../buildings.dart';

class Lumber extends StatelessWidget {
  const Lumber({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BuildingsBloc, BuildingsState>(
      builder: (context, state) {
        return Column(
          children: [
            ...state.settlement!.buildings
                .where((bR) => bR[1] == 0)
                .map((e) => FieldViewTile(
                      buildingRecord: e,
                      storage: state.settlement!.storage,
                    ))
                .toList()
          ],
        );
      },
    );
  }
}
