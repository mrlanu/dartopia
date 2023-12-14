import 'dart:math';

import 'package:dartopia/rally_point/rally_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';

import '../../../settlement/settlement.dart';

class ConfirmSendTroops extends StatelessWidget {
  const ConfirmSendTroops({super.key, required this.onConfirm});

  final Function() onConfirm;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
        child: BlocBuilder<SendTroopsCubit, SendTroopsState>(
          builder: (context, state) {
            final currentSettlement =
                context.read<SettlementBloc>().state.settlement!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Confirmation',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Target: ${state.tileDetails!.name} (${state.tileDetails!.x}|${state.tileDetails!.y})',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Player: ${state.tileDetails!.playerName}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                TroopDetails(
                    isEstimate: true,
                    movement: Movement.sendConfirmation(
                        mission: 1,
                        units: state.units,
                        when: _getArrivalTime(
                            _getDistance(
                              state.tileDetails!.x,
                              state.tileDetails!.y,
                              currentSettlement.x,
                              currentSettlement.y,
                            ),
                            300), // should be changed for real speed of slowest unit
                        // in units,
                        // and change in the settlementService on the server as well
                        from: SideBrief(
                            villageId: currentSettlement.id.$oid,
                            coordinates: [
                              currentSettlement.x,
                              currentSettlement.y
                            ],
                            playerName: currentSettlement.userId,
                            villageName: currentSettlement.name),
                        to: SideBrief(
                            villageId: state.tileDetails!.id,
                            villageName: state.tileDetails!.name,
                            playerName: state.tileDetails!.playerName,
                            coordinates: [
                              state.tileDetails!.x,
                              state.tileDetails!.y
                            ]))),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton.outlined(
                          color: Colors.green,
                          onPressed: () {
                            context
                                .read<SendTroopsCubit>()
                                .setStatus(SendTroopsStatus.selecting);
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                          )),
                      const SizedBox(
                        width: 30,
                      ),
                      IconButton.outlined(
                          color: Colors.green,
                          onPressed: () async {
                            final movBloc = context.read<MovementsBloc>();
                            final settlementId = context
                                .read<SettlementBloc>()
                                .state
                                .settlement!
                                .id
                                .$oid;
                            await context
                                .read<SendTroopsCubit>()
                                .sendTroops(currentSettlementId: settlementId);
                            movBloc.add(MovementsFetchRequested(
                                settlementId: settlementId));
                            onConfirm();
                          },
                          icon: const Icon(
                            Icons.check,
                          )),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  DateTime _getArrivalTime(double distance, int speed) {
    final double hours = distance / speed;
    final int seconds = (hours * 3600).round();
    DateTime arrivalDateTime = DateTime.now().add(Duration(seconds: seconds));
    return arrivalDateTime;
  }

  double _getDistance(int x, int y, int fromX, int fromY) {
    var legX = pow(x - fromX, 2);
    var legY = pow(y - fromY, 2);
    return sqrt(legX + legY);
  }
}
