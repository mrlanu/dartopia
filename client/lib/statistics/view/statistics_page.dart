import 'package:dartopia/settlement/bloc/settlement_bloc.dart';
import 'package:dartopia/statistics/statistics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../statistics_repository.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatisticsCubit(
          statisticsRepository: context.read<StatisticsRepository>())
        ..fetchStatistics(),
      child: const StatisticsView(),
    );
  }
}

class StatisticsView extends StatelessWidget {
  const StatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TableFilter(),
        BlocConsumer<SettlementBloc, SettlementState>(
          listener: (context, state) {
            context.read<StatisticsCubit>().fetchStatistics();
          },
          builder: (context, state) {
            return BlocBuilder<StatisticsCubit, StatisticsState>(
              builder: (context, state) {
                return state.statisticsStatus == StatisticsStatus.loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : StatisticsTable(
                        staticsModels: state.statisticsResponse!.modelsList,
                      );
              },
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
