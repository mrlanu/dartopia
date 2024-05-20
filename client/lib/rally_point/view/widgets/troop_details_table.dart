import 'package:dartopia/consts/images.dart';
import 'package:dartopia/settlement/bloc/settlement_bloc.dart';
import 'package:dartopia/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:models/models.dart';

class TroopDetailsTable extends StatelessWidget {
  const TroopDetailsTable(
      {super.key,
      required this.movement,
      this.isEstimate = false,
      this.hideName = false,
      this.backgroundColor = Colors.white70});

  final Movement movement;
  final bool isEstimate; // used in confirm_send_troops form
  final Color backgroundColor;
  final bool hideName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(
        builder: (context, constraints) => Column(
          children: [
            _firstRow(constraints.maxWidth),
            _secondRow(constraints.maxWidth),
            _thirdRow(constraints.maxWidth),
            _forthRow(
                isEstimate,
                constraints.maxWidth,
                const Color.fromRGBO(215, 215, 215, 1.0),
                movement.when,
                context),
          ],
        ),
      ),
    );
  }

  Widget _firstRow(double maxWidth) {
    return Row(
      children: [
        Container(
          width: maxWidth * 0.2,
          height: 22,
          decoration: BoxDecoration(
            color: _getBackgroundColor(),
            border: const Border(
              top: BorderSide(color: Colors.black),
              bottom: BorderSide(color: Colors.black),
              left: BorderSide(color: Colors.black),
              right: BorderSide(color: Colors.black),
              // Skip the right side border
            ),
          ),
          child: Center(
              child: Text(
            movement.mission == Mission.back
                ? movement.to.villageName
                : movement.from.villageName,
            overflow: TextOverflow.ellipsis,
          )),
        ),
        Expanded(
          child: Container(
            height: 22,
            decoration: BoxDecoration(
              color: _getBackgroundColor(),
              border: const Border(
                top: BorderSide(color: Colors.black),
                bottom: BorderSide(color: Colors.black),
                right: BorderSide(color: Colors.black),
                // Skip the right side border
              ),
            ),
            child: movement.isMoving
                ? Center(
                    child: Text(
                        overflow: TextOverflow.ellipsis,
                        movement.mission == Mission.back
                            ? 'Return from ${movement.from.villageName} '
                                '(${movement.from.coordinates[0]}|${movement.from.coordinates[1]})'
                            : '${hideName ? '' : movement.from.playerName} ${_getMissionName()} ${movement.to.villageName} '
                                '(${movement.to.coordinates[0]}|${movement.to.coordinates[1]})'))
                : movement.mission == Mission.home
                    ? const Center(child: Text('Own troops'))
                    : Center(
                        child: Text(
                            overflow: TextOverflow.ellipsis,
                            '${movement.from.playerName} ${_getMissionName()} ${movement.to.villageName} (${movement.to.coordinates[0]}|${movement.to.coordinates[1]})'),
                      ),
          ),
        ),
      ],
    );
  }

  String _getMissionName() {
    return switch (movement.mission) {
      Mission.attack => 'attacks',
      Mission.home => 'home',
      Mission.back => 'backs',
      Mission.caught => 'caught',
      Mission.raid => 'raids',
      Mission.reinforcement => 'reinforces',
    };
  }

  Color _getBackgroundColor() {
    return switch (movement.mission) {
      Mission.attack ||
      Mission.raid =>
        const Color.fromRGBO(252, 209, 209, 1.0),
      Mission.home => const Color.fromRGBO(250, 238, 178, 1.0),
      Mission.reinforcement ||
      Mission.back =>
        const Color.fromRGBO(202, 246, 179, 1.0),
      _ => const Color.fromRGBO(252, 209, 209, 1.0),
    };
  }

  Widget _secondRow(double maxWidth) {
    return Row(
      children: [
        Container(
          width: maxWidth * 0.2,
          height: 22,
          decoration: BoxDecoration(
            color: backgroundColor,
            border: const Border(
              bottom: BorderSide(color: Colors.black),
              left: BorderSide(color: Colors.black),
              right: BorderSide(color: Colors.black),
              // Skip the right side border
            ),
          ),
          child: Center(
              child: Text(
                  '${movement.from.coordinates[0]} | ${movement.from.coordinates[1]}')),
        ),
        ...movement.units
            .asMap()
            .entries
            .map((e) => Container(
                  width: (maxWidth - maxWidth * 0.2) / 10,
                  height: 22,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    border: const Border(
                      bottom: BorderSide(color: Colors.black),
                      right: BorderSide(color: Colors.black),
                      // Skip the right side border
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 16.0,
                      height: 16.0,
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        image: DecorationImage(
                          alignment: Alignment(-1.0 + 0.218 * e.key, 0.0),
                          image: const AssetImage(DartopiaImages.gauls),
                          // Replace with your actual image path
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ))
            .toList(),
      ],
    );
  }

  Widget _thirdRow(double maxWidth) {
    return Row(
      children: [
        Container(
          width: maxWidth * 0.2,
          height: 22,
          decoration: BoxDecoration(
            color: backgroundColor,
            border: const Border(
              bottom: BorderSide(color: Colors.black),
              left: BorderSide(color: Colors.black),
              right: BorderSide(color: Colors.black),
              // Skip the right side border
            ),
          ),
          child: const Center(child: Text('Troops')),
        ),
        ...movement.units
            .map((e) => Container(
                  width: (maxWidth - maxWidth * 0.2) / 10,
                  height: 22,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    border: const Border(
                      bottom: BorderSide(color: Colors.black),
                      right: BorderSide(color: Colors.black),
                      // Skip the right side border
                    ),
                  ),
                  child: Center(
                      child: Text(
                    '$e',
                    overflow: TextOverflow.ellipsis,
                  )),
                ))
            .toList(),
      ],
    );
  }

  Widget _forthRow(bool isEstimate, double maxWidth, Color backgroundColor,
      DateTime? arrivalTime, BuildContext context) {
    return Row(
      children: [
        Container(
          width: maxWidth * 0.2,
          height: 22,
          decoration: BoxDecoration(
            color: backgroundColor,
            border: const Border(
              bottom: BorderSide(color: Colors.black),
              left: BorderSide(color: Colors.black),
              right: BorderSide(color: Colors.black),
              // Skip the right side border
            ),
          ),
          child: movement.isMoving
              ? const Center(child: Text('Arrival'))
              : const Center(child: Text('Maintenance')),
        ),
        Expanded(
          child: Container(
              height: 22,
              decoration: BoxDecoration(
                color: backgroundColor,
                border: const Border(
                  bottom: BorderSide(color: Colors.black),
                  right: BorderSide(color: Colors.black),
                  // Skip the right side border
                ),
              ),
              child: isEstimate // USED on send troops confirmation form
                  ? _buildRowForEstimateArrival()
                  : movement.isMoving
                      ? _buildRowForMovingUnits(context)
                      : _buildRowForStaticUnits()),
        ),
      ],
    );
  }

  Widget _buildRowForMovingUnits(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                'in ',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              CountdownTimer(
                textStyle: Theme.of(context).textTheme.bodySmall,
                startValue: movement.when.difference(DateTime.now()).inSeconds,
                onFinish: () {
                  context
                      .read<SettlementBloc>()
                      .add(const SettlementFetchRequested());
                },
              ),
            ],
          ),
          movement.mission == Mission.back
              ? _buildPlunder(plunder: movement.plunder, context: context)
              : Container(),
          Text(
            'at ${DateFormat('HH:mm:ss').format(movement.when.subtract(const Duration(hours: 6)))}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildRowForStaticUnits() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('6'),
        Image.asset(
          DartopiaImages.crop,
          width: 16,
          height: 16,
        ),
        const Text('hour'),
      ],
    );
  }

  Widget _buildRowForEstimateArrival() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
            ' in ${FormatUtil.formatTime(movement.when.difference(DateTime.now()).inSeconds)}'),
        Row(
          children: [
            const Text('at '),
            CountUp(startTime: movement.when),
            const SizedBox(
              width: 6,
            )
          ],
        ),
      ],
    );
  }

  Widget _buildPlunder(
      {required List<int> plunder, required BuildContext context}) {
    final images = [
      DartopiaImages.lumber,
      DartopiaImages.clay,
      DartopiaImages.iron,
      DartopiaImages.crop
    ];
    return Row(children: [
      ...plunder
          .asMap()
          .entries
          .map((e) => Row(
                children: [
                  Image.asset(
                    images[e.key],
                    width: 12,
                    height: 12,
                  ),
                  Text(
                    '${plunder[e.key]}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(
                    width: 2,
                  )
                ],
              ))
          .toList()
    ]);
  }
}
