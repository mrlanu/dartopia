import 'package:dartopia/consts/images.dart';
import 'package:flutter/material.dart';

class TroopDetails extends StatelessWidget {
  const TroopDetails(
      {super.key,
      this.troops = const [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      this.arrivalTime,
      this.backgroundColor = Colors.white70});

  final List<int> troops;
  final DateTime? arrivalTime;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(
        builder: (context, constraints) => ListView(
          children: [
            _firstRow(constraints.maxWidth, Colors.green),
            _secondRow(constraints.maxWidth),
            _thirdRow(constraints.maxWidth),
            _forthRow(constraints.maxWidth, Colors.grey, arrivalTime),
          ],
        ),
      ),
    );
  }

  Widget _firstRow(double maxWidth, Color backgroundColor) {
    return Row(
      children: [
        Container(
          width: maxWidth * 0.3,
          height: 22,
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border(
              top: BorderSide(color: Colors.black),
              bottom: BorderSide(color: Colors.black),
              left: BorderSide(color: Colors.black),
              right: BorderSide(color: Colors.black),
              // Skip the right side border
            ),
          ),
          child: Center(child: Text('Peppa\'s village')),
        ),
        Expanded(
          child: Container(
            height: 22,
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border(
                top: BorderSide(color: Colors.black),
                bottom: BorderSide(color: Colors.black),
                right: BorderSide(color: Colors.black),
                // Skip the right side border
              ),
            ),
            child: Center(child: Text('Own troops')),
          ),
        ),
      ],
    );
  }

  Widget _secondRow(double maxWidth) {
    return Row(
      children: [
        Container(
          width: maxWidth * 0.3,
          height: 22,
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border(
              bottom: BorderSide(color: Colors.black),
              left: BorderSide(color: Colors.black),
              right: BorderSide(color: Colors.black),
              // Skip the right side border
            ),
          ),
          child: Center(child: Text('(-96 | -93)')),
        ),
        ...troops
            .asMap()
            .entries
            .map((e) => Container(
                  width: (maxWidth - maxWidth * 0.3) / 10,
                  height: 22,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    border: Border(
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
                          alignment: Alignment(-1.0 + 0.224 * e.key, 0.0),
                          image: AssetImage(DartopiaImages.troops),
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
          width: maxWidth * 0.3,
          height: 22,
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border(
              bottom: BorderSide(color: Colors.black),
              left: BorderSide(color: Colors.black),
              right: BorderSide(color: Colors.black),
              // Skip the right side border
            ),
          ),
          child: Center(child: Text('Troops')),
        ),
        ...troops
            .map((e) => Container(
                  width: (maxWidth - maxWidth * 0.3) / 10,
                  height: 22,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    border: Border(
                      bottom: BorderSide(color: Colors.black),
                      right: BorderSide(color: Colors.black),
                      // Skip the right side border
                    ),
                  ),
                  child: Center(child: Text('$e')),
                ))
            .toList(),
      ],
    );
  }

  Widget _forthRow(
      double maxWidth, Color backgroundColor, DateTime? arrivalTime) {
    return Row(
      children: [
        Container(
          width: maxWidth * 0.3,
          height: 22,
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border(
              bottom: BorderSide(color: Colors.black),
              left: BorderSide(color: Colors.black),
              right: BorderSide(color: Colors.black),
              // Skip the right side border
            ),
          ),
          child: arrivalTime == null
              ? Center(child: Text('Maintanance'))
              : Center(child: Text('Arrival')),
        ),
        Expanded(
          child: Container(
            height: 22,
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border(
                bottom: BorderSide(color: Colors.black),
                right: BorderSide(color: Colors.black),
                // Skip the right side border
              ),
            ),
            child: arrivalTime == null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('6'),
                      Image.asset(
                        DartopiaImages.crop,
                        width: 16,
                        height: 16,
                      ),
                      Text('hour'),
                    ],
                  )
                : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('in 00:45:07'),
                        Text('at 13:20:09'),
                      ],
                    ),
                ),
          ),
        ),
      ],
    );
  }
}
