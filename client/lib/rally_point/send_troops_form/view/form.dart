import 'package:dartopia/rally_point/rally_point.dart';
import 'package:dartopia/settlement/bloc/settlement_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';

import '../../../consts/images.dart';

class SendTroopsForm extends StatelessWidget {
  const SendTroopsForm({super.key, this.tileDetails, required this.onConfirm});

  final TileDetails? tileDetails;
  final Function() onConfirm;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovementsBloc, MovementsState>(
      builder: (context, state) {
        return state.movements[MovementLocation.home]!.isNotEmpty
            ? BlocProvider(
                create: (context) => SendTroopsCubit(
                    troopMovementsRepository:
                        context.read<TroopMovementsRepository>())
                  ..setTileDetails(tileDetails),
                child: SendTroopsFormView(onConfirm: onConfirm),
              )
            : Container();
      },
    );
  }
}

class SendTroopsFormView extends StatelessWidget {
  const SendTroopsFormView({super.key, required this.onConfirm});

  final Function() onConfirm;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
        child: Card(
          elevation: 5,
          child: BlocBuilder<SendTroopsCubit, SendTroopsState>(
            builder: (context, state) {
              final availableUnits =
                  context.read<SettlementBloc>().state.settlement!.units;
              return state.status == SendTroopsStatus.selecting ||
                      state.status == SendTroopsStatus.processing
                  ? Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildCoordinates(state.tileDetails?.x ?? 0,
                              state.tileDetails?.y ?? 0, context),
                          const Divider(),
                          GridView.count(
                            padding: const EdgeInsets.only(
                                left: 40, top: 5, bottom: 5),
                            crossAxisCount: 2,
                            childAspectRatio: (4 / 1),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            children: [
                              ...state.units
                                  .asMap()
                                  .entries
                                  .map((e) => Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: _buildField(
                                          e.key,
                                          availableUnits[e.key],
                                          state.units[e.key],
                                          context)))
                                  .toList(),
                            ],
                          ),
                          const Divider(),
                          _buildTargets(state.target1, state.target2,
                              state.options, context),
                          const Divider(),
                          _buildRadioGroup(state.mission, context),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: IconButton.outlined(
                                color: Colors.green,
                                onPressed: () {
                                  context.read<SendTroopsCubit>().submitForm();
                                },
                                icon:
                                    state.status == SendTroopsStatus.processing
                                        ? const SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator())
                                        : const Icon(
                                            Icons.arrow_forward,
                                          )),
                          ),
                        ],
                      ),
                    )
                  : ConfirmSendTroops(
                      onConfirm: onConfirm,
                    );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCoordinates(int x, int y, BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              Text(
                'X: ',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(
                width: width * 0.15,
                child: TextFormField(
                  initialValue: x.toString(),
                  onChanged: (value) {
                    context
                        .read<SendTroopsCubit>()
                        .setX(int.tryParse(value) ?? 0);
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'Y: ',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(
                width: width * 0.15,
                child: TextFormField(
                  initialValue: y.toString(),
                  onChanged: (value) {
                    context
                        .read<SendTroopsCubit>()
                        .setY(int.tryParse(value) ?? 0);
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildField(
      int index, int availableAmount, int amount, BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cubit = context.read<SendTroopsCubit>();
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                image: DecorationImage(
                  alignment: Alignment(-1.0 + 0.224 * index, 0.0),
                  image: const AssetImage(DartopiaImages.troops),
                  // Replace with your actual image path
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(
            width: width * 0.15,
            child: TextFormField(
              initialValue: amount.toString(),
              onChanged: (value) {
                final intValue = int.tryParse(value) ?? 0;
                final maxAmount =
                    intValue > availableAmount ? availableAmount : intValue;
                cubit.setUnit(index, maxAmount);
              },
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                NumericRangeFormatter(0, availableAmount),
              ],
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(left: 5),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          SizedBox(
              width: width * 0.15, child: Text('/ $availableAmount')),
        ],
      ),
    );
  }

  Widget _buildRadioGroup(Mission mission, BuildContext context) {
    final cubit = context.read<SendTroopsCubit>();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 160,
              child: ListTile(
                title: const Text('Attack'),
                leading: Radio(
                  value: Mission.attack,
                  groupValue: mission,
                  onChanged: (value) {
                    cubit.setMission(value as Mission);
                  },
                ),
              ),
            ),
            SizedBox(
              width: 160,
              child: ListTile(
                title: const Text('Raid'),
                leading: Radio(
                  value: Mission.raid,
                  groupValue: mission,
                  onChanged: (value) {
                    cubit.setMission(value as Mission);
                  },
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          width: 220,
          child: ListTile(
            title: const Text('Reinforcement'),
            leading: Radio(
              value: Mission.reinforcement,
              groupValue: mission,
              onChanged: (value) {
                cubit.setMission(value as Mission);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTargets(String? selected1, String? selected2,
      List<String> options, BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: width * 0.4,
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(left: 10),
                border: OutlineInputBorder(),
              ),
              value: selected1,
              onChanged: (newValue) {},
              items: options.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          SizedBox(
            width: width * 0.02,
          ),
          SizedBox(
            width: width * 0.4,
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(left: 10),
                border: OutlineInputBorder(),
              ),
              value: selected2,
              onChanged: (newValue) {},
              items: options.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class NumericRangeFormatter extends TextInputFormatter {
  final int minValue;
  final int maxValue;

  NumericRangeFormatter(this.minValue, this.maxValue);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    try {
      final int parsedValue = int.parse(newValue.text);

      if (parsedValue < minValue) {
        return TextEditingValue(
          text: minValue.toString(),
          selection:
              TextSelection.collapsed(offset: minValue.toString().length),
        );
      } else if (parsedValue > maxValue) {
        return TextEditingValue(
          text: maxValue.toString(),
          selection:
              TextSelection.collapsed(offset: maxValue.toString().length),
        );
      }
    } catch (e) {
      // Handle non-numeric input
    }

    return newValue;
  }
}
