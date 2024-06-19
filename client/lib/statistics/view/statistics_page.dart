import 'package:dartopia/statistics/statistics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return
      const StatisticsView();
  }
}

class StatisticsView extends StatelessWidget {
  const StatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TableFilter(),
        BlocBuilder<StatisticsCubit, StatisticsState>(
              builder: (context, state) {
                return state.statisticsStatus == StatisticsStatus.loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : StatisticsTable(
                        staticsModels: state.statisticsResponse!.modelsList,
                      );
              },
        ),
        const Spacer(),
        const Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Paginator(),
        ),
      ],
    );
  }
}
