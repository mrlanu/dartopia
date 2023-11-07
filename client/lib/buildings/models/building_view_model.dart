import 'package:flutter/material.dart';
import 'package:models/models.dart';

class BuildingViewModel {
  final BuildingId id;
  final String name;
  final String description;
  final String imagePath;
  final int level;
  final List<int> costToNextLevel;
  final int timeToNextLevel;
  final List<RequirementBuilding> requirementBuildings;
  final Widget widget;

  BuildingViewModel(
      {required this.id,
      required this.name,
      this.level = 0,
      required this.description,
      required this.imagePath,
      required this.costToNextLevel,
      required this.timeToNextLevel,
      this.requirementBuildings = const [],
      required this.widget});

  BuildingViewModel copyWith(
      {BuildingId? id,
      String? name,
      String? description,
      String? imagePath,
      int? level,
      double? k,
      List<int>? costToNextLevel,
      int? timeToNextLevel,
      List<RequirementBuilding>? requirementBuildings}) {
    return BuildingViewModel(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        imagePath: imagePath ?? this.imagePath,
        level: level ?? this.level,
        costToNextLevel: costToNextLevel ?? this.costToNextLevel,
        timeToNextLevel: timeToNextLevel ?? this.timeToNextLevel,
        requirementBuildings: requirementBuildings ?? this.requirementBuildings,
        widget: widget);
  }
}
