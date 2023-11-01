import 'package:flutter/material.dart';
import 'package:models/models.dart';

class BuildingViewModel {
  final BuildingId id;
  final String name;
  final String description;
  final String imagePath;
  final int level;
  final List<int> cost;
  final List<RequirementBuilding> requirementBuildings;
  final Widget widget;

  BuildingViewModel(
      {required this.id,
      required this.name,
      this.level = 0,
      required this.description,
      required this.imagePath,
      required this.cost,
      this.requirementBuildings = const [],
      required this.widget});

  BuildingViewModel copyWith(
      {BuildingId? id,
      String? name,
      String? description,
      String? imagePath,
      int? level,
      double? k,
      List<int>? cost,
      List<RequirementBuilding>? requirementBuildings}) {
    return BuildingViewModel(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        imagePath: imagePath ?? this.imagePath,
        level: level ?? this.level,
        cost: cost ?? this.cost,
        requirementBuildings: requirementBuildings ?? this.requirementBuildings,
        widget: widget);
  }
}
