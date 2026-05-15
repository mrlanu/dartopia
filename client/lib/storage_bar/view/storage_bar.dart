import 'dart:async';

import 'package:dartopia/settlement/bloc/settlement_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final dividerForCrop =
        (producePerHour[3] - _settlement.calculateEatPerHour()) == 0
            ? 1
            : (producePerHour[3] - _settlement.calculateEatPerHour());
    _timers.add(_startTimer(
        milliseconds: 3600000 ~/ dividerForCrop, resource: Resource.CROP));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: _barBuilder(itemsList: [
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
          ),
          //SizedBox(width: 1.w),
          Expanded(
            flex: 1,
            child: _barBuilder(
              itemsList: [
                _itemBuilder(
                    amount: _settlement.storage[3].toInt(),
                    maxCapacity: _settlement.getMaxCapacity(5).toInt(),
                    pngName: 'crop'),
              ],
            ),
          ),
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
              if (_settlement.storage[3] <= 0) {
                context
                    .read<SettlementBloc>()
                    .add(const SettlementFetchRequested());
              }
            });
            break;
        }
      });

  Widget _barBuilder(
      {required List<Widget> itemsList, Color backgroundColor = Colors.grey}) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (final item in itemsList) item,
          ],
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
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/images/resources/$pngName.png',
                  width: 16.w,
                  height: 16.w,
                  fit: BoxFit.contain,
                ),
                SizedBox(width: 5.w),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    amount > maxCapacity
                        ? maxCapacity.toString()
                        : amount <= 0
                            ? '0'
                            : amount.toString(),
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: pngName == 'crop'
                            ? isCropNegative
                                ? Colors.red
                                : Colors.black
                            : Colors.black),
                  ),
                ),
              ],
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                LinearPercentIndicator(
                  barRadius: Radius.circular(8.r),
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0),
                  animation: false,
                  width: 58.w,
                  lineHeight: 12.h,
                  percent:
                      amount <= maxCapacity ? amount / maxCapacity : 1.0,
                  progressColor: _getColor(amount, maxCapacity),
                ),
                Positioned(
                  child: Text(
                    maxCapacity.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall!
                        .copyWith(color: Colors.black, fontSize: 9.sp),
                  ),
                ),
              ],
            )
          ],
        ),
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
