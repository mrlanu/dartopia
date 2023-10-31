import 'package:flutter/material.dart';

import '../../models/building_model.dart';

class BuildingPicture extends StatelessWidget {
  const BuildingPicture({
    super.key,
    this.width = 90.0,
    this.height = 90.0,
    required this.buildingModel,
  });

  final BuildingModel buildingModel;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        fit: BoxFit.cover,
        buildingModel.imagePath,
        width: width,
        height: height,
      ),
    );
  }
}
