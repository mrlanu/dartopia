import 'package:flutter/material.dart';
import 'package:models/models.dart';

class BuildingPicture extends StatelessWidget {
  const BuildingPicture(
      {super.key,
      this.width = 90.0,
      this.height = 90.0,
      required this.buildingRecord,
      this.prodPerHour});

  final List<int> buildingRecord;
  final double width;
  final double height;
  final int? prodPerHour;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(children: [
        Image.asset(
          fit: BoxFit.cover,
          buildingSpecefication[buildingRecord[1]]!.imagePath,
          width: width,
          height: height,
        ),
        prodPerHour != null
            ? Positioned(
          bottom: 0,
                right: 0,
                child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  '${prodPerHour!}',
                  style: prodPerHour! > 10000
                      ? Theme.of(context).textTheme.bodySmall
                      : Theme.of(context).textTheme.titleSmall,
                ),
              ))
            : const SizedBox(),
      ]),
    );
  }
}
