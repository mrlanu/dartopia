import 'package:flutter/material.dart';
import 'package:models/models.dart';

class BuildingPicture extends StatelessWidget {
  const BuildingPicture({
    super.key,
    this.width = 90.0,
    this.height = 90.0,
    required this.buildingRecord,
  });

  final List<int> buildingRecord;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        fit: BoxFit.cover,
        buildingSpecefication[buildingRecord[1]]!.imagePath,
        width: width,
        height: height,
      ),
    );
  }
}
