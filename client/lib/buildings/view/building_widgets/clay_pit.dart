import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../buildings.dart';

class ClayPit extends StatelessWidget {
  const ClayPit({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BuildingsBloc, BuildingsState>(
      builder: (context, state) {
        return Column(
          children: [
            ...state.settlement!.buildings
                .where((bR) => bR[1] == 1)
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
