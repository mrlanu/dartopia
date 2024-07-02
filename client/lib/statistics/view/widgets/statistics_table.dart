import 'package:dartopia/consts/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../cubit/statistics_cubit.dart';

class StatisticsTable extends StatelessWidget {
  const StatisticsTable({super.key, required this.staticsModels});

  final List<StatisticsModel> staticsModels;

  @override
  Widget build(BuildContext context) {
    final filter =
        context.select((StatisticsCubit cubit) => cubit.state.sortStat);
    return FutureBuilder(
      future: SharedPreferences.getInstance().then(
            (value) => value.getString('name'),
      ),
      builder: (context, snapshot) {
        return snapshot.hasData ? Table(
          columnWidths: filter == SortStat.overview
              ? {
            0: const FixedColumnWidth(40.0),
            1: const FixedColumnWidth(110.0),
            2: const FixedColumnWidth(110.0),
            3: const FixedColumnWidth(70.0),
            4: const FixedColumnWidth(60.0),
          }
              : {
            0: const FixedColumnWidth(40.0),
            1: const FixedColumnWidth(90.0),
            2: const FixedColumnWidth(80.0),
            3: const FixedColumnWidth(60.0),
            4: const FixedColumnWidth(60.0),
            5: const FixedColumnWidth(60.0),
          },
          children: [
            switch (filter) {
              SortStat.overview =>
                  _buildHeader(['', 'Player', 'Alliance', 'Populations', 'Villages']),
              SortStat.attacker => _buildHeader(
                  ['', 'Player', 'Alliance', 'Populations', 'Villages', 'Points']),
              SortStat.defender => _buildHeader(
                  ['', 'Player', 'Alliance', 'Populations', 'Villages', 'Points']),
              SortStat.top => _buildHeader(
                  ['', 'Player', 'Alliance', 'Populations', 'Villages', 'Points']),
            },
            ...switch (filter) {
              SortStat.overview => staticsModels.map(
                    (m) => _buildDataRow([
                  m.position.toString(),
                  m.playerName,
                  m.allianceName,
                  m.population.toString(),
                  m.villagesAmount.toString()
                ], snapshot.data!),
              ),
              SortStat.attacker => staticsModels.map(
                    (m) => _buildDataRow([
                  m.position.toString(),
                  m.playerName,
                  m.allianceName,
                  m.population.toString(),
                  m.villagesAmount.toString(),
                  m.attackPoint.toString()
                ], snapshot.data!),
              ),
              SortStat.defender => staticsModels.map(
                    (m) => _buildDataRow([
                  m.position.toString(),
                  m.playerName,
                  m.allianceName,
                  m.population.toString(),
                  m.villagesAmount.toString(),
                  m.defensePoint.toString()
                ], snapshot.data!),
              ),
              SortStat.top => throw UnimplementedError(),
            },
            // Add more TableRows for additional data rows
          ],
        ) : Container();
      },
    );
  }

  TableRow _buildHeader(List<String> data) {
    return TableRow(
      decoration: const BoxDecoration(color: DartopiaColors.primary),
      children: [
        ...List.generate(
          data.length,
          (index) => TableCell(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  data[index],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  TableRow _buildDataRow(List<String> data, String playerName) {
    return TableRow(
      decoration: BoxDecoration(
        color: data[1] == playerName ? DartopiaColors.primaryContainer : null,
        border: const Border(bottom: BorderSide(color: Colors.grey, width: 1.0)),
      ),
      children: [
        ...List.generate(
          data.length,
          (index) => TableCell(
            child: GestureDetector(
              onTap: () => print(data[1]),
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  data[index],
                  overflow: TextOverflow.ellipsis,
                ),
              )),
            ),
          ),
        ),
      ],
    );
  }
}
