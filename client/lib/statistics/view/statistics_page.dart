import 'package:dartopia/statistics/statistics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const StatisticsView();
  }
}

class StatisticsView extends StatelessWidget {
  const StatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: TableFilter(),
            ),
            Expanded(
              child: BlocBuilder<StatisticsCubit, StatisticsState>(
                builder: (context, state) {
                  if (state.statisticsStatus == StatisticsStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return StatisticsTable(
                    staticsModels: state.statisticsResponse!.modelsList,
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Paginator(),
            ),
          ],
        ),
      ),
    );
  }
}
