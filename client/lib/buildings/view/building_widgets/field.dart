import 'package:dartopia/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../buildings.dart';

class Field extends StatelessWidget {
  const Field({super.key, required this.position});

  final int position;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BuildingsBloc, BuildingsState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              ...state.settlement!.buildings
                  .where((bR) => bR[1] == position - offsetForFieldsCarousel)
                  .map((e) {
                final upgradingTask = state.settlement!.constructionTasks
                    .where((task) =>
                        task.position == e[0] && task.buildingId == e[1])
                    .toList();
                return upgradingTask.isNotEmpty
                    ? FieldViewTile(
                        buildingRecord: e,
                        storage: state.settlement!.storage,
                        isUpgrading: upgradingTask[0]
                            .executionTime
                            .difference(DateTime.now())
                            .inSeconds,
                      )
                    : FieldViewTile(
                        buildingRecord: e,
                        storage: state.settlement!.storage,
                      );
              }).toList()
            ],
          ),
        );
      },
    );
  }
}
