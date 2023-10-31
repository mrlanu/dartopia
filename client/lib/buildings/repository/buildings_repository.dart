import '../models/buildings_consts.dart';

abstract class BuildingsRepository {
  Future<List<BuildingModelRepo>> fetchBuildings();
}

class BuildingsRepositoryImpl extends BuildingsRepository{
  @override
  Future<List<BuildingModelRepo>> fetchBuildings() async {
    return buildings;
  }

}

List<BuildingModelRepo> buildings = [
  BuildingModelRepo(id: BuildingId.MAIN, level: 1),
  BuildingModelRepo(id: BuildingId.BARRACKS, level: 1),
  BuildingModelRepo(id: BuildingId.EMPTY, level: 1),
  BuildingModelRepo(id: BuildingId.GRAIN_MILL, level: 1),
  BuildingModelRepo(id: BuildingId.GRANARY, level: 1),
];

class BuildingModelRepo {
  final BuildingId id;
  final int level;

  BuildingModelRepo({required this.id, required this.level});
}
