import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_paginator/number_paginator.dart';

import '../../cubit/statistics_cubit.dart';

class Paginator extends StatelessWidget {
  const Paginator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final statResponse =
        context.select((StatisticsCubit bloc) => bloc.state.statisticsResponse);
    final totalPageInt = statResponse != null ? statResponse.totalPages : 2;
    final currentPage = statResponse != null ? statResponse.currentPage : 1;
    return NumberPaginator(
      key: UniqueKey(),
      config: NumberPaginatorUIConfig(
          buttonSelectedBackgroundColor: Colors.orange,
          buttonTextStyle: Theme.of(context).textTheme.displayLarge),
      numberPages: totalPageInt,
      initialPage: currentPage - 1,
      onPageChange: (int index) {
        context
            .read<StatisticsCubit>()
            .fetchStatistics(page: (index + 1).toString());
      },
    );
  }
}
