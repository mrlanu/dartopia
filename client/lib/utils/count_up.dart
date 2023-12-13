import 'dart:async';

import 'package:flutter/material.dart';

class CountUp extends StatefulWidget {
  CountUp({super.key, this.textStyle, DateTime? startTime})
      : _startTime = startTime ?? DateTime.now();
  final DateTime _startTime;
  final TextStyle? textStyle;

  @override
  State<CountUp> createState() => _CountUpState();
}

class _CountUpState extends State<CountUp> {
  late Timer timer;
  late DateTime arrivalTime;
  late String arrivalTimeStr;


  @override
  void initState() {
    super.initState();
    arrivalTime = widget._startTime;
    arrivalTimeStr = _formatDate(widget._startTime);
    timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        setState(() {
          arrivalTime = arrivalTime.add(const Duration(seconds: 1));
          arrivalTimeStr = _formatDate(arrivalTime);
        });
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  String _formatDate(DateTime date){
    String hours = date.hour < 10 ? '0${date.hour}' : date.hour.toString();
    String mins = date.minute < 10 ? '0${date.minute}' : date.minute.toString();
    String secs = date.second < 10 ? '0${date.second}' : date.second.toString();
    return '$hours:$mins:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return Text(arrivalTimeStr, style: widget.textStyle,);
  }
}
