import 'dart:async';

import 'package:dartopia/settlement/bloc/settlement_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class StorageBar extends StatefulWidget {
  const StorageBar({super.key, required this.settlement});

  final Settlement settlement;

  @override
  State<StorageBar> createState() => _StorageBarState();
}

class _StorageBarState extends State<StorageBar> {
  late Settlement _settlement;
  final List<Timer> _timers = [];
  bool isCropNegative = false;

  @override
  void didUpdateWidget(covariant StorageBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.settlement != oldWidget.settlement) {
      for (var element in _timers) {
        element.cancel();
      }
      _timers.clear();
      setState(() {
        _settlement = widget.settlement;
      });
      _startCounting();
    }
  }

  @override
  void initState() {
    super.initState();
    _settlement = widget.settlement;
    _startCounting();
  }

  @override
  void dispose() {
    super.dispose();
    for (var element in _timers) {
      element.cancel();
    }
  }

  void _startCounting() {
    final producePerHour = _settlement.calculateProducePerHour();
    isCropNegative =
        (producePerHour[3] - _settlement.calculateEatPerHour()) < 0;
    _timers.add(_startTimer(
        milliseconds: 3600000 ~/ producePerHour[0], resource: Resource.WOOD));
    _timers.add(_startTimer(
        milliseconds: 3600000 ~/ producePerHour[1], resource: Resource.CLAY));
    _timers.add(_startTimer(
        milliseconds: 3600000 ~/ producePerHour[2], resource: Resource.IRON));
    _timers.add(_startTimer(
        milliseconds:
            3600000 ~/ (producePerHour[3] - _settlement.calculateEatPerHour()),
        resource: Resource.CROP));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _barBuilder(itemsList: [
            _itemBuilder(
                amount: _settlement.storage[0].toInt(),
                maxCapacity: _settlement.getMaxCapacity(6).toInt(),
                pngName: 'lumber'),
            _itemBuilder(
                amount: _settlement.storage[1].toInt(),
                maxCapacity: _settlement.getMaxCapacity(6).toInt(),
                pngName: 'clay'),
            _itemBuilder(
                amount: _settlement.storage[2].toInt(),
                maxCapacity: _settlement.getMaxCapacity(6).toInt(),
                pngName: 'iron'),
          ]),
          _barBuilder(
            itemsList: [
              _itemBuilder(
                  amount: _settlement.storage[3].toInt(),
                  maxCapacity: _settlement.getMaxCapacity(5).toInt(),
                  pngName: 'crop'),
            ],
          )
        ],
      ),
    );
  }

  Timer _startTimer({required Resource resource, required int milliseconds}) =>
      Timer.periodic(Duration(milliseconds: milliseconds.abs()), (timer) {
        switch (resource) {
          case Resource.WOOD:
            setState(() {
              _settlement.storage[0]++;
            });
            break;
          case Resource.CLAY:
            setState(() {
              _settlement.storage[1]++;
            });
            break;
          case Resource.IRON:
            setState(() {
              _settlement.storage[2]++;
            });
            break;
          case Resource.CROP:
            setState(() {
              milliseconds >= 0
                  ? _settlement.storage[3]++
                  : _settlement.storage[3]--;
              if(_settlement.storage[3] <= 0 ){
                context.read<SettlementBloc>().add(const SettlementFetchRequested());
              }
            });
            break;
        }
      });

  Widget _barBuilder(
      {required List<Widget> itemsList, Color backgroundColor = Colors.grey}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [...itemsList],
        ),
      ),
    );
  }

  Widget _itemBuilder({
    required int amount,
    required int maxCapacity,
    required String pngName,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Image.asset('assets/images/resources/$pngName.png'),
        Column(
          children: [
            Text(
              amount > maxCapacity
                  ? maxCapacity.toString()
                  : amount <= 0
                      ? '0'
                      : amount.toString(),
              style: TextStyle(
                  color: pngName == 'crop'
                      ? isCropNegative
                          ? Colors.red
                          : Colors.black
                      : Colors.black,
                  fontSize: 15),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                LinearPercentIndicator(
                  barRadius: const Radius.circular(5),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 3, vertical: 0),
                  animation: false,
                  width: 60.0,
                  lineHeight: 10.0,
                  percent: amount <= maxCapacity ? amount / maxCapacity : 1.0,
                  progressColor: _getColor(amount, maxCapacity),
                ),
                Positioned(
                  child: Text(
                    maxCapacity.toString(),
                    style: const TextStyle(color: Colors.black, fontSize: 10),
                  ),
                ),
              ],
            )
          ],
        )
      ],
    );
  }

  Color _getColor(int amount, int maxCapacity) {
    if (amount < maxCapacity / 2) {
      return Colors.green;
    } else if (amount < maxCapacity - (maxCapacity / 4)) {
      return Colors.green;
    } else if (amount < maxCapacity) {
      return Colors.orange;
    } else if (amount == maxCapacity) {
      return Colors.red;
    } else {
      return Colors.red;
    }
  }
}
