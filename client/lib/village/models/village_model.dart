import 'package:equatable/equatable.dart';

import '../../buildings/repository/buildings_repository.dart';

class VillageModel extends Equatable {
  final String id;
  final String name;
  final List<double> storage;
  final List<BuildingModelRepo> buildings;

  const VillageModel(
      {required this.id,
      required this.name,
      this.storage = const [0, 0, 0, 0],
      this.buildings = const []});

  @override
  List<Object?> get props => [id, name, storage, buildings];
}
