import 'package:flutter/material.dart';

import 'buildings_consts.dart';

class BuildingModel {
  final BuildingId id;
  final String name;
  final String description;
  final String imagePath;
  final int level;
  final double k;
  final List<int> cost;
  final List<(BuildingId, int)> buildingsReq;
  final Widget? widget;

  BuildingModel(
      {required this.id,
      required this.name,
      this.level = 0,
      required this.description,
      required this.imagePath,
      required this.k,
      required this.cost,
      this.buildingsReq = const [],
      this.widget});

  BuildingModel copyWith(
      {BuildingId? id,
      String? name,
      String? description,
      String? imagePath,
      int? level,
      double? k,
      List<int>? cost,
      List<(BuildingId, int)>? buildingsReq}) {
    return BuildingModel(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        imagePath: imagePath ?? this.imagePath,
        level: level ?? this.level,
        k: k ?? this.k,
        cost: cost ?? this.cost,
        buildingsReq: buildingsReq ?? this.buildingsReq,
        widget: widget);
  }
}
