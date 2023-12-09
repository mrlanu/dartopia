import 'package:dartopia/rally_point/rally_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../consts/images.dart';

class SendTroopsForm extends StatelessWidget {
  const SendTroopsForm({super.key, this.x, this.y});

  final int? x;
  final int? y;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovementsBloc, MovementsState>(
      builder: (context, state) {
        return state.movements[MovementLocation.home]!.isNotEmpty
            ? BlocProvider(
                create: (context) => SendTroopsCubit()
                  ..setX(x ?? 0)
                  ..setY(y ?? 0),
                child: const SendTroopsFormView(),
              )
            : Container();
      },
    );
  }
}

class SendTroopsFormView extends StatelessWidget {
  const SendTroopsFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 5),
        child: Card(
          child: BlocBuilder<SendTroopsCubit, SendTroopsState>(
            builder: (context, state) {
              return Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildCoordinates(state.x, state.y, context),
                    const Divider(),
                    GridView.count(
                      padding:
                          const EdgeInsets.only(left: 40, top: 10, bottom: 10),
                      crossAxisCount: 2,
                      childAspectRatio: (5 / 1),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: [
                        ...state.units
                            .asMap()
                            .entries
                            .map((e) => Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: _buildField(
                                    e.key, state.units[e.key], context)))
                            .toList(),
                      ],
                    ),
                    const Divider(),
                    _buildTargets(
                        state.target1, state.target2, state.options, context),
                    const Divider(),
                    _buildRadioGroup(state.kind, context),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: IconButton.outlined(
                          color: Colors.green,
                          onPressed: () {
                            context.read<SendTroopsCubit>().submitForm();
                          },
                          icon: const Icon(Icons.arrow_forward)),
                    ),
                  ],
                ),
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
                  onChanged: (value) {},
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
                  onChanged: (value) {},
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

  Widget _buildField(int index, int amount, BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cubit = context.read<SendTroopsCubit>();
    return Row(
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
            onChanged: (value) {
              cubit.setUnit(index, int.parse(value));
            },
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
        SizedBox(width: width * 0.15, child: Text('/ $amount')),
      ],
    );
  }

  Widget _buildRadioGroup(int kind, BuildContext context) {
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
                  value: 0,
                  groupValue: kind,
                  onChanged: (value) {
                    cubit.setKind(value!);
                  },
                ),
              ),
            ),
            SizedBox(
              width: 160,
              child: ListTile(
                title: const Text('Raid'),
                leading: Radio(
                  value: 1,
                  groupValue: kind,
                  onChanged: (value) {
                    cubit.setKind(value!);
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
              value: 2,
              groupValue: kind,
              onChanged: (value) {
                cubit.setKind(value!);
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
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
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
          Container(
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
