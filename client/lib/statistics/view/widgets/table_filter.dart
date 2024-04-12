import 'package:dartopia/consts/colors.dart';
import 'package:dartopia/statistics/cubit/statistics_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TableFilter extends StatelessWidget {
  const TableFilter({super.key});

  @override
  Widget build(BuildContext context) {
    final sort =
        context.select((StatisticsCubit cubit) => cubit.state.sortStat);
    const selectedColor = DartopiaColors.primary;
    return Wrap(
      spacing: 3,
      children: [
        ChoiceChip(
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
          ),
          padding: EdgeInsets.zero,
          selectedColor: selectedColor,
          checkmarkColor: Colors.white,
          label: Text(
            'Overview',
            style:
                TextStyle(color: sort.index == 0 ? Colors.white : Colors.black),
          ),
          selected: sort.index == 0,
          onSelected: (value) {
            value
                ? context.read<StatisticsCubit>().changeSort(SortStat.values[0])
                : null;
          },
        ),
        ChoiceChip(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(color: Colors.transparent),
          ),
          padding: EdgeInsets.zero,
          selectedColor: selectedColor,
          checkmarkColor: Colors.white,
          label: Text(
            'Attacker',
            style:
                TextStyle(color: sort.index == 1 ? Colors.white : Colors.black),
          ),
          selected: sort.index == 1,
          onSelected: (value) {
            value
                ? context.read<StatisticsCubit>().changeSort(SortStat.values[1])
                : null;
          },
        ),
        ChoiceChip(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(color: Colors.transparent),
          ),
          padding: EdgeInsets.zero,
          selectedColor: selectedColor,
          checkmarkColor: Colors.white,
          label: Text(
            'Defender',
            style:
                TextStyle(color: sort.index == 2 ? Colors.white : Colors.black),
          ),
          selected: sort.index == 2,
          onSelected: (value) {
            value
                ? context.read<StatisticsCubit>().changeSort(SortStat.values[2])
                : null;
          },
        ),
        ChoiceChip(
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          padding: EdgeInsets.zero,
          selectedColor: selectedColor,
          checkmarkColor: Colors.white,
          label: Text(
            'Top 10',
            style:
                TextStyle(color: sort.index == 3 ? Colors.white : Colors.black),
          ),
          selected: sort.index == 3,
          onSelected: (value) {
            value
                ? context.read<StatisticsCubit>().changeSort(SortStat.values[3])
                : null;
          },
        ),
      ],
    );
  }
}
