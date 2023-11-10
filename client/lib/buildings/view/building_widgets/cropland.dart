import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../buildings.dart';


class Cropland extends StatelessWidget {
  const Cropland({super.key, required this.position});

  final int position;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BuildingsBloc, BuildingsState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              ...state.settlement!.buildings
                  .where((bR) => bR[1] == 3)
                  .map((e) => FieldViewTile(buildingRecord: e))
                  .toList()
            ],
          ),
        );
      },
    );
  }
}
