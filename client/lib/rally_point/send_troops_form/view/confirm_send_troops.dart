import 'package:dartopia/buildings/buildings.dart';
import 'package:dartopia/rally_point/rally_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';

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
                context.read<BuildingsBloc>().state.settlement!;
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
                        distance: 1,
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
                            await context.read<SendTroopsCubit>().sendTroops();
                            context.read<MovementsBloc>().add(
                                const MovementsFetchRequested(
                                    settlementId: '654eaeb5693f198560bc1e5a'));
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
}
