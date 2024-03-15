import 'package:dartopia/consts/colors.dart';
import 'package:dartopia/consts/images.dart';
import 'package:dartopia/settlement/settlement.dart';
import 'package:dartopia/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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
            for (final troopId in settlement.availableUnits)
              _TroopOrderForm(unitId: troopId, settlement: settlement),
            settlement.combatUnitQueue.isNotEmpty
                ? _InTrainingTable(
                    key: UniqueKey(),
                    lastModifiedDate: settlement.lastModified,
                    combatUnitQueue: settlement.combatUnitQueue)
                : Container(),
          ],
        )));
      },
    );
  }
}

class _TroopOrderForm extends StatefulWidget {
  const _TroopOrderForm({required this.unitId, required this.settlement});

  final int unitId;
  final Settlement settlement;

  @override
  State<_TroopOrderForm> createState() => _TroopOrderFormState();
}

class _TroopOrderFormState extends State<_TroopOrderForm> {
  late TextEditingController _textEditingController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final settlementBloc = context.read<SettlementBloc>();
    final amount = _parseString(_textEditingController.text);
    final settlementRepo = context.read<SettlementRepository>();
    try {
      await settlementRepo.orderUnits(
          settlementId: widget.settlement.id.$oid,
          unitId: widget.unitId,
          amount: amount);
      _textEditingController.clear();
      _formKey.currentState!.reset();
      settlementBloc.add(const SettlementFetchRequested());
    } catch (e) {}
  }

  int _parseString(String text) {
    int result;
    try {
      result = int.parse(text);
    } catch (e) {
      result = 0;
    }
    return result;
  }

  int _calculateMaxUnitsAmount(List<int> cost, List<double> storage) {
    int minResult = 1000000;
    for (int i = 0; i < storage.length; i++) {
      int result = storage[i] ~/ cost[i];
      minResult = result < minResult ? result : minResult;
    }
    return minResult;
  }

  @override
  Widget build(BuildContext context) {
    final unit = UnitsConst.UNITS[widget.settlement.nation.index][widget.unitId];
    final maxAmount =
        _calculateMaxUnitsAmount(unit.cost, widget.settlement.storage);
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(unit.name),
                        const Text(' Level 0'),
                        Text(
                            '( present ${widget.settlement.units[widget.unitId]})'),
                      ],
                    ),
                    _CostBar(unitId: widget.unitId),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: constraints.maxWidth * 0.2,
                          child: _buildAmountFormInput(maxAmount),
                        ),
                        GestureDetector(
                          onTap: () => _textEditingController.text =
                              maxAmount.toString(),
                          child: Text(' / $maxAmount'),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        SizedBox(
                          height: 25,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _onSubmit();
                              }
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

  Widget _buildAmountFormInput(int maxAmount) {
    final size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: TextFormField(
        controller: _textEditingController,
        style: TextStyle(fontSize: size.width * 0.04),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          labelStyle: TextStyle(
              fontSize: size.width * 0.04, color: DartopiaColors.black),
          border: const OutlineInputBorder(),
          errorStyle: const TextStyle(height: 0.01),
          labelText: 'Amount',
        ),
        validator: (value) {
          if (value == null ||
              value.isEmpty ||
              _parseString(value) <= 0 ||
              _parseString(value) > maxAmount) {
            return '';
          }
          return null;
        },
        onSaved: (newValue) {},
      ),
    );
  }
}

class _CostBar extends StatelessWidget {
  const _CostBar({required this.unitId});

  final int unitId;

  @override
  Widget build(BuildContext context) {
    final unit = UnitsConst.UNITS[0][unitId];
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

class _InTrainingTable extends StatefulWidget {
  const _InTrainingTable(
      {super.key,
      required this.combatUnitQueue,
      required this.lastModifiedDate});

  final List<CombatUnitQueue> combatUnitQueue;
  final DateTime lastModifiedDate;

  @override
  State<_InTrainingTable> createState() => _InTrainingTableState();
}

class _InTrainingTableState extends State<_InTrainingTable> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: LayoutBuilder(
            builder: (context, constraints) => Column(
              children: [
                _header(constraints.maxWidth),
                for (final c in widget.combatUnitQueue)
                  _tableRow(c, constraints.maxWidth),
                _footer(constraints.maxWidth),
              ],
            ),
          ),
        ),
      ],
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

  Widget _tableRow(CombatUnitQueue combatUnitQueue, double maxWidth) {
    final Unit unit = UnitsConst.UNITS[0][combatUnitQueue.unitId];
    final durationInSeconds = combatUnitQueue.durationEach -
        widget.lastModifiedDate.difference(combatUnitQueue.lastTime).inSeconds +
        (combatUnitQueue.leftTrain - 1) * combatUnitQueue.durationEach;
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text('${combatUnitQueue.leftTrain} ${unit.name}'),
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
            child: Center(
              child: CountdownTimer(
                startValue: durationInSeconds,
                onFinish: () {},
              ),
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
            child: Center(
              child: Text(DateFormat('HH:mm:ss').format(
                  DateTime.now().add(Duration(seconds: durationInSeconds)))),
            ),
          ),
        ),
      ],
    );
  }

  Widget _footer(double maxWidth) {
    final nextUnitDuration = widget.combatUnitQueue.first.durationEach -
        widget.lastModifiedDate
            .difference(widget.combatUnitQueue.first.lastTime)
            .inSeconds;
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
      child: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Next unit will be ready in '),
          CountdownTimer(
              startValue: nextUnitDuration,
              onFinish: () {
                context
                    .read<SettlementBloc>()
                    .add(const SettlementFetchRequested());
              })
        ],
      )),
    );
  }
}
