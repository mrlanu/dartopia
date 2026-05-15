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
    final textTheme = Theme.of(context).textTheme;

    return FutureBuilder<String?>(
      future: SharedPreferences.getInstance().then(
        (value) => value.getString('name'),
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }
        final playerName = snapshot.data!;

        return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: Table(
                    columnWidths: _columnWidths(filter),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      switch (filter) {
                        SortStat.overview => _buildHeader(
                            context,
                            ['', 'Player', 'Alliance', 'Populations', 'Villages'],
                          ),
                        SortStat.attacker => _buildHeader(
                            context,
                            [
                              '',
                              'Player',
                              'Alliance',
                              'Populations',
                              'Villages',
                              'Points'
                            ],
                          ),
                        SortStat.defender => _buildHeader(
                            context,
                            [
                              '',
                              'Player',
                              'Alliance',
                              'Populations',
                              'Villages',
                              'Points'
                            ],
                          ),
                        SortStat.top => _buildHeader(
                            context,
                            [
                              '',
                              'Player',
                              'Alliance',
                              'Populations',
                              'Villages',
                              'Points'
                            ],
                          ),
                      },
                      ...switch (filter) {
                        SortStat.overview => staticsModels.map(
                            (m) => _buildDataRow(
                                  context,
                                  textTheme,
                                  [
                                    m.position.toString(),
                                    m.playerName,
                                    m.allianceName,
                                    m.population.toString(),
                                    m.villagesAmount.toString(),
                                  ],
                                  playerName,
                                ),
                          ),
                        SortStat.attacker => staticsModels.map(
                            (m) => _buildDataRow(
                                  context,
                                  textTheme,
                                  [
                                    m.position.toString(),
                                    m.playerName,
                                    m.allianceName,
                                    m.population.toString(),
                                    m.villagesAmount.toString(),
                                    m.attackPoint.toString(),
                                  ],
                                  playerName,
                                ),
                          ),
                        SortStat.defender => staticsModels.map(
                            (m) => _buildDataRow(
                                  context,
                                  textTheme,
                                  [
                                    m.position.toString(),
                                    m.playerName,
                                    m.allianceName,
                                    m.population.toString(),
                                    m.villagesAmount.toString(),
                                    m.defensePoint.toString(),
                                  ],
                                  playerName,
                                ),
                          ),
                        SortStat.top => throw UnimplementedError(),
                      },
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Map<int, TableColumnWidth> _columnWidths(SortStat filter) {
    if (filter == SortStat.overview) {
      return const {
        0: FixedColumnWidth(32),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(1.2),
        4: FlexColumnWidth(1),
      };
    }
    return const {
      0: FixedColumnWidth(32),
      1: FlexColumnWidth(2),
      2: FlexColumnWidth(1.5),
      3: FlexColumnWidth(1.2),
      4: FlexColumnWidth(1),
      5: FlexColumnWidth(1),
    };
  }

  TableRow _buildHeader(BuildContext context, List<String> data) {
    final headerStyle = Theme.of(context)
        .textTheme
        .labelMedium!
        .copyWith(color: Colors.white, fontWeight: FontWeight.w600);

    return TableRow(
      decoration: const BoxDecoration(color: DartopiaColors.primary),
      children: [
        for (final label in data)
          TableCell(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Text(
                label,
                style: headerStyle,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ),
      ],
    );
  }

  TableRow _buildDataRow(
    BuildContext context,
    TextTheme textTheme,
    List<String> data,
    String playerName,
  ) {
    final cellStyle = textTheme.bodySmall;
    final isCurrentPlayer = data.length > 1 && data[1] == playerName;

    return TableRow(
      decoration: BoxDecoration(
        color: isCurrentPlayer ? DartopiaColors.primaryContainer : null,
        border: const Border(
          bottom: BorderSide(color: Colors.grey, width: 1.0),
        ),
      ),
      children: [
        for (final cell in data)
          TableCell(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Text(
                cell,
                style: cellStyle,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ),
      ],
    );
  }
}
