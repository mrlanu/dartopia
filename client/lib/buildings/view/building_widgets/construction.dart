import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';

import '../../../settlement/settlement.dart';
import '../../../utils/countdown.dart';

class Construction extends StatelessWidget {
  final List<int> buildingRecord;

  const Construction({super.key, required this.buildingRecord});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettlementBloc, SettlementState>(
      builder: (context, state) {
        final upgradingTask = state.settlement!.constructionTasks
            .where((task) => task.position == buildingRecord[0])
            .toList();
        return upgradingTask.isEmpty
            ? const SizedBox()
            : Card(
                elevation: 5,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  height: 390,
                  child: Column(
                    children: [
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            '${buildingSpecefication[upgradingTask[0].buildingId]!.name} to level ${upgradingTask[0].toLevel}',
                            style: Theme.of(context).textTheme.titleLarge,
                          )),
                      const Divider(),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Ready in:',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          CountdownTimer(
                            startValue: upgradingTask[0]
                                .executionTime
                                .difference(DateTime.now())
                                .inSeconds,
                            onFinish: () {
                              context
                                  .read<SettlementBloc>()
                                  .add(const SettlementFetchRequested());
                            },
                            textStyle: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      )),
                      const Divider(),
                      IconButton.outlined(
                          color: Colors.red,
                          onPressed: () {},
                          icon: const Icon(Icons.cancel_outlined))
                    ],
                  ),
                ));
      },
    );
  }
}
