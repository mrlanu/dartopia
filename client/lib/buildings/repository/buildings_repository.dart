
import 'package:models/models.dart';

abstract class BuildingsRepository {
  Future<List<BuildingModelRepo>> fetchBuildings();
}

class BuildingsRepositoryImpl extends BuildingsRepository{
  @override
  Future<List<BuildingModelRepo>> fetchBuildings() async {
    return [];
  }

}

class BuildingModelRepo {
  final BuildingId id;
  final int level;

  BuildingModelRepo({required this.id, required this.level});
}
