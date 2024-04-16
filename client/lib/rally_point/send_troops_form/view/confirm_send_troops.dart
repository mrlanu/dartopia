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
                    'Target: ${state.contract!.name} (${state.contract!.corX}|${state.contract!.corY})',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Player: ${state.contract!.playerName}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                TroopDetailsTable(
                    hideName: true,
                    isEstimate: true,
                    movement: _createMovement(state, currentSettlement)),
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
                            final settlementBloc =
                                context.read<SettlementBloc>();
                            final settlementId = context
                                .read<SettlementBloc>()
                                .state
                                .settlement!
                                .id
                                .$oid;
                            await context
                                .read<SendTroopsCubit>()
                                .sendTroops(currentSettlementId: settlementId);
                            onConfirm();
                            settlementBloc
                                .add(const SettlementFetchRequested());
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

  Movement _createMovement(
      SendTroopsState state, Settlement currentSettlement) {
    return Movement(
        mission: state.mission,
        units: state.units,
        when: state.contract!.when,
        from: SideBrief(
            villageId: currentSettlement.id.$oid,
            coordinates: [currentSettlement.x, currentSettlement.y],
            playerName: currentSettlement.userId,
            userId: currentSettlement.userId,
            villageName: currentSettlement.name),
        to: SideBrief(
            villageId: state.contract!.settlementId!,
            villageName: state.contract!.name!,
            playerName: state.contract!.ownerId!,
            userId: state.contract!.ownerId!,
            coordinates: [state.contract!.corX, state.contract!.corY]));
  }
}
