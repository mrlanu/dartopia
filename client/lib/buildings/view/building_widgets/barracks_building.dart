import 'package:dartopia/consts/calors.dart';
import 'package:dartopia/consts/images.dart';
import 'package:dartopia/utils/time_formatter.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

import '../../buildings.dart';

class BarracksBuilding extends StatelessWidget {
  const BarracksBuilding({super.key, required this.buildingRecord});

  final List<int> buildingRecord;

  @override
  Widget build(BuildContext context) {
    return BuildingContainer(
      key: ValueKey('${buildingRecord[1]} ${buildingRecord[0]}'),
      buildingRecord: buildingRecord,
      child: (settlement, buildingRecord) {
        return Expanded(
            child: SingleChildScrollView(
                child: Column(
          children: [
            const _TroopOrderForm(),
            const _TroopOrderForm(),
            const _TroopOrderForm(),
            const _TroopOrderForm(),
            const Divider(),
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    'In progress',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                )),
            const _InTrainingTable(),
          ],
        )));
      },
    );
  }
}

class _TroopOrderForm extends StatefulWidget {
  const _TroopOrderForm();

  @override
  State<_TroopOrderForm> createState() => _TroopOrderFormState();
}

class _TroopOrderFormState extends State<_TroopOrderForm> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Card(
        color: DartopiaColors.primaryContainer,
        elevation: 3.0,
        child: Row(
          children: [
            Container(
              height: 100,
              width: constraints.maxWidth * 0.23,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
                image: DecorationImage(
                  image: AssetImage(DartopiaImages.phalang),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              height: 100,
              width: constraints.maxWidth * 0.72,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Legionnaire'),
                        Text(' Level 0'),
                        Text('( present 2)'),
                      ],
                    ),
                    const _CostBar(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: constraints.maxWidth * 0.2,
                          child: _buildAmountFormInput(),
                        ),
                        const Text(' / 4'),
                        const SizedBox(
                          width: 30,
                        ),
                        SizedBox(
                          height: 25,
                          child: ElevatedButton(
                            onPressed: () {
                              // Add your button click logic here
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: DartopiaColors.primary,
                              // Set the text color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    8.0), // Customize the button shape
                              ),
                            ),
                            child: const Text(
                              'Train', // Button text
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildAmountFormInput() {
    final size = MediaQuery.of(context).size;
    return TextFormField(
      initialValue: '0',
      style: TextStyle(fontSize: size.width * 0.04),
      onChanged: (name) {},
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        labelStyle:
            TextStyle(fontSize: size.width * 0.04, color: DartopiaColors.black),
        border: const OutlineInputBorder(),
        labelText: 'Amount',
      ),
      validator: (value) {
        if (value == null ||
            value.isEmpty ||
            value.trim().length <= 3 ||
            value.trim().length > 20) {
          return 'Must be at least 3 characters long';
        }
        return null;
      },
      onSaved: (newValue) {},
    );
  }
}

class _CostBar extends StatelessWidget {
  const _CostBar();

  @override
  Widget build(BuildContext context) {
    final unit = UnitsConst.UNITS[2][0];
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      _buildResItem(unit: unit, imagePath: DartopiaImages.lumber, position: 0),
      _buildResItem(unit: unit, imagePath: DartopiaImages.clay, position: 1),
      _buildResItem(unit: unit, imagePath: DartopiaImages.iron, position: 2),
      _buildResItem(unit: unit, imagePath: DartopiaImages.crop, position: 3),
      _buildUpkeep(unit: unit),
      _buildTime(unit: unit),
    ]);
  }

  Widget _buildResItem(
      {required Unit unit, required String imagePath, required int position}) {
    final resToNextLvl = unit.cost;
    return Row(children: [
      Image.asset(imagePath, width: 12, height: 12),
      Text(
        '${resToNextLvl[position]}  ',
        style: const TextStyle(fontSize: 12),
      )
    ]);
  }

  Widget _buildUpkeep({required Unit unit}) {
    return Row(children: [
      Image.asset(DartopiaImages.crop, width: 12, height: 12),
      Text(
        '${unit.upKeep}   ',
        style: const TextStyle(fontSize: 12),
      )
    ]);
  }

  Widget _buildTime({required Unit unit}) {
    return Row(children: [
      Image.asset(DartopiaImages.clock, width: 12, height: 12),
      Text(
        ' ${FormatUtil.formatTime(unit.time)}  ',
        style: const TextStyle(fontSize: 12),
      )
    ]);
  }
}

class _InTrainingTable extends StatelessWidget {
  const _InTrainingTable();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(
        builder: (context, constraints) => Column(
          children: [
            _header(constraints.maxWidth),
            _tableRow(constraints.maxWidth),
            _tableRow(constraints.maxWidth),
            _tableRow(constraints.maxWidth),
            _tableRow(constraints.maxWidth),
            _footer(constraints.maxWidth),
          ],
        ),
      ),
    );
  }

  Widget _header(double maxWidth) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            width: maxWidth * 0.2,
            height: 22,
            decoration: const BoxDecoration(
              color: DartopiaColors.tertiaryContainer,
              border: Border(
                top: BorderSide(color: Colors.black),
                bottom: BorderSide(color: Colors.black),
                left: BorderSide(color: Colors.black),
                right: BorderSide(color: Colors.black),
                // Skip the right side border
              ),
            ),
            child: const Center(child: Text('Units')),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            height: 22,
            decoration: const BoxDecoration(
              color: DartopiaColors.tertiaryContainer,
              border: Border(
                top: BorderSide(color: Colors.black),
                bottom: BorderSide(color: Colors.black),
                right: BorderSide(color: Colors.black),
                // Skip the right side border
              ),
            ),
            child: const Center(
              child: Text('Duration'),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            height: 22,
            decoration: const BoxDecoration(
              color: DartopiaColors.tertiaryContainer,
              border: Border(
                top: BorderSide(color: Colors.black),
                bottom: BorderSide(color: Colors.black),
                right: BorderSide(color: Colors.black),
                // Skip the right side border
              ),
            ),
            child: const Center(
              child: Text('Finished'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _tableRow(double maxWidth) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            alignment: Alignment.centerLeft,
            width: maxWidth * 0.2,
            height: 22,
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(color: Colors.black),
                right: BorderSide(color: Colors.black),
                // Skip the right side border
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Text('2 Legionnaire'),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            height: 22,
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(color: Colors.black),
                // Skip the right side border
              ),
            ),
            child: const Center(
              child: Text('0:56:34'),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            height: 22,
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(color: Colors.black),
                // Skip the right side border
              ),
            ),
            child: const Center(
              child: Text('03:34:09'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _footer(double maxWidth) {
    return Container(
      width: maxWidth,
      height: 22,
      decoration: const BoxDecoration(
        color: DartopiaColors.lighterGrey,
        border: Border(
          top: BorderSide(color: Colors.black),
          bottom: BorderSide(color: Colors.black),
          left: BorderSide(color: Colors.black),
          right: BorderSide(color: Colors.black),
          // Skip the right side border
        ),
      ),
      child: const Center(child: Text('Next unit will be ready in 0:26:03')),
    );
  }
}
