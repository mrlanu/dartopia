import 'dart:async';

import 'package:dartopia/utils/time_formatter.dart';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  const CountdownTimer(
      {super.key,
      required this.startValue,
      required this.onFinish,
      this.textStyle});

  final int startValue;
  final Function() onFinish;
  final TextStyle? textStyle;

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer timer;
  late int timeResume;

  @override
  void initState() {
    timeResume = widget.startValue;
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (timeResume == 0) {
          widget.onFinish();
          timer.cancel();
        } else {
          setState(() {
            timeResume--;
          });
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      FormatUtil.formatTime(timeResume),
      style: widget.textStyle,
    );
  }
}
