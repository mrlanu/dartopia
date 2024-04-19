import 'package:dartopia/buildings/buildings.dart';
import 'package:dartopia/utils/countdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';

import '../../../settlement/settlement.dart';
import '../view.dart';

class RallyPoint extends StatelessWidget {
  const RallyPoint({super.key, required this.buildingRecord});

  final List<int> buildingRecord;

  @override
  Widget build(BuildContext context) {
    final settlementBloc = context.read<SettlementBloc>();
    return BuildingContainer(
      key: ValueKey('${buildingRecord[1]} ${buildingRecord[0]}'),
      buildingRecord: buildingRecord,
      enterable: true,
      onEnter: () => context.push('/rally_point/0'),
      child: (settlement, buildingRecord) {
        return _buildInfo(settlementBloc.state.movementsByLocationMap, context);
      },
    );
  }

  Widget _buildInfo(
      Map<MovementLocation, List<Movement>> movements, BuildContext context) {
    final incomingAttacks = movements[MovementLocation.incoming]!
        .where((m) => m.mission == Mission.attack || m.mission == Mission.raid)
        .toList();
    final outgoingAttacks = movements[MovementLocation.outgoing]!
        .where((m) => m.mission == Mission.attack || m.mission == Mission.raid)
        .toList();
    final incomingReinforcements = movements[MovementLocation.incoming]!
        .where((m) =>
            m.mission == Mission.reinforcement || m.mission == Mission.back)
        .toList();
    final outgoingReinforcements = movements[MovementLocation.outgoing]!
        .where((m) => m.mission == Mission.reinforcement)
        .toList();
    return incomingAttacks.isEmpty &&
            incomingReinforcements.isEmpty &&
            outgoingAttacks.isEmpty &&
            outgoingReinforcements.isEmpty
        ? const Center(
            child: Text('No incoming or outgoing troops.'),
          )
        : BlocBuilder<SettlementBloc, SettlementState>(
            builder: (context, state) {
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    incomingAttacks.isNotEmpty ||
                            incomingReinforcements.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Incoming troops:',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              incomingAttacks.isNotEmpty
                                  ? _buildTitle(
                                      incomingAttacks,
                                      incomingAttacks.length > 1
                                          ? 'attacks'
                                          : 'attack',
                                      context)
                                  : Container(),
                              incomingReinforcements.isNotEmpty
                                  ? _buildTitle(
                                      incomingReinforcements,
                                      incomingReinforcements.length > 1
                                          ? 'reinforcements'
                                          : 'reinforcement',
                                      context)
                                  : Container()
                            ],
                          )
                        : Container(),
                    (incomingAttacks.isNotEmpty ||
                                incomingReinforcements.isNotEmpty) &&
                            (outgoingAttacks.isNotEmpty ||
                                outgoingReinforcements.isNotEmpty)
                        ? const Divider(
                            indent: 70,
                            endIndent: 70,
                          )
                        : Container(),
                    outgoingAttacks.isNotEmpty ||
                            outgoingReinforcements.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Outgoing troops:',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              outgoingAttacks.isNotEmpty
                                  ? _buildTitle(
                                      outgoingAttacks,
                                      outgoingAttacks.length > 1
                                          ? 'attacks'
                                          : 'attack',
                                      context)
                                  : Container(),
                              outgoingReinforcements.isNotEmpty
                                  ? _buildTitle(
                                      outgoingReinforcements,
                                      outgoingReinforcements.length > 1
                                          ? 'reinforcements'
                                          : 'reinforcement',
                                      context)
                                  : Container()
                            ],
                          )
                        : Container(),
                  ],
                ),
              );
            },
          );
  }

  Widget _buildTitle(
      List<Movement> movements, String actionText, BuildContext context) {
    return Row(
      children: [
        Text(
          '${movements.length} $actionText in ',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        CountdownTimer(
          startValue: movements[0].when.difference(DateTime.now()).inSeconds,
          onFinish: () {
            context
                .read<SettlementBloc>()
                .add(const SettlementFetchRequested());
          },
        ),
        Text(
          ' hrs.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
