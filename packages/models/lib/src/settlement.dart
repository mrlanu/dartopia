import 'package:collection/collection.dart';
import 'package:models/models.dart';

import 'package:models/src/construction_task.dart';
import 'package:mongo_dart/mongo_dart.dart';

/// The `Settlement` class
class Settlement {
  /// Creates a new `Settlement`.
  Settlement({
    required this.id,
    required this.userId,
    this.name = 'New village',
    this.storage = const [500.0, 500.0, 500.0, 500.0],
    this.buildings = const [
      BuildingRecord(id: 0, level: 1),
      BuildingRecord(id: 1, level: 1),
      BuildingRecord(id: 2, level: 1),
      BuildingRecord(id: 3, level: 1),
      BuildingRecord(id: 4, level: 1),
    ],
    this.army = const [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    this.constructionTasks = const [],
    this.combatUnitQueue = const [],
    DateTime? lastModified,
  }) : lastModified = lastModified ?? DateTime.now();

  Settlement.fromMap(Map<String, dynamic> map)
      : id = map['_id'] as ObjectId,
        name = map['name'] as String,
        userId = map['userId'] as String,
        storage = (map['storage'] as List<dynamic>)
            .map((e) => (e as num).toDouble())
            .toList(),
        buildings = (map['buildings'] as List<dynamic>)
            .map((e) => BuildingRecord.fromMap(e as Map<String, dynamic>))
            .toList(),
        army = (map['army'] as List<dynamic>).map((e) => e as int).toList(),
        constructionTasks = (map['constructionTasks'] as List<dynamic>)
            .map((e) => ConstructionTask.fromMap(e as Map<String, dynamic>))
            .toList(),
        combatUnitQueue = (map['combatUnitQueue'] as List<dynamic>)
            .map((e) => CombatUtitQueue.fromMap(e as Map<String, dynamic>))
            .toList(),
        lastModified = map['lastModified'] as DateTime;

  ObjectId id;
  final String userId;
  String name;
  List<double> storage;
  List<BuildingRecord> buildings;
  List<int> army;
  List<ConstructionTask> constructionTasks;
  List<CombatUtitQueue> combatUnitQueue;
  DateTime lastModified;

  /// Add new ConstructionTask to constructionTasks list
  void addConstructionTask(ConstructionTask task) {
    constructionTasks.add(task);
  }

  /// Add new CombatUnitQueue to combatUnitQueue list
  void addCombatUnitOrder(CombatUtitQueue order) {
    combatUnitQueue.add(order);
  }

  /// Calculate the resource production per hour for specific buildings.
  ///
  /// This function filters the `buildings` list to select buildings with
  /// specific `id` values, groups them by `id`, and calculates the total
  /// production based on each building's level.
  ///
  /// Returns a list of integers representing the production per hour for
  /// each building type. The order in the list corresponds to the building
  /// types with IDs 1, 2, 3, and 4.
  List<int> calculateProducePerHour() {
    // Filter buildings based on specific `id` values (1, 2, 3, 4).
    final resourceBuilding = buildings
        .where(
          (b) =>
          b.id == BuildingId.WOODCUTTER.index ||
              b.id == BuildingId.CLAY_PIT.index ||
              b.id == BuildingId.IRON_MINE.index||
              b.id == BuildingId.CROPLAND.index,
        )
        .toList();

    // Group the filtered buildings by `id`.
    final groupedBuildings = groupBy(
      resourceBuilding,
      (BuildingRecord b) => b.id,
    );

    // Calculate the total production for each building type.
    final reducedMap = groupedBuildings.map((key, value) {
      final sum = value.fold(0, (a, b) {
        final benefit = buildingSpecefication[b.id].benefit(b.level);
        return a + benefit;
      });
      return MapEntry(key, sum);
    });

    // Create a list to store the production per hour for each building type.
    final result = List<int>.filled(4, 0);

    var index = 0;
    reducedMap.forEach((key, value) {
      result[index] = value;
      index++;
    });

    return result;
  }

  /// Calculate the production of wood, clay, iron, and crop resources
  /// over a specified duration and updates the resource storage with
  /// the new values.
  void calculateProducedGoods({DateTime? toDateTime}) {
    toDateTime ??= DateTime.now();
    final producePerHour = calculateProducePerHour();
    print('P/H: $producePerHour');
    final durationSinceLastModified =
        toDateTime.difference(lastModified).inSeconds;
    final divider = durationSinceLastModified / 3600;
    final woodProduced = producePerHour[0] * divider;
    final clayProduced = producePerHour[1] * divider;
    final ironProduced = producePerHour[2] * divider;
    final cropProduced = producePerHour[3] * divider;
    final newStorage = [
      double.parse((storage[0] + woodProduced).toStringAsFixed(4)),
      double.parse((storage[1] + clayProduced).toStringAsFixed(4)),
      double.parse((storage[2] + ironProduced).toStringAsFixed(4)),
      double.parse((storage[3] + cropProduced).toStringAsFixed(4)),
    ];
    storage = newStorage;
    lastModified = toDateTime;
  }

  void castStorage() {
    for (var i = 0; i < storage.length - 1; i++) {
      if (storage[i] > _getWarehouseCapacity()) {
        storage[i] = _getWarehouseCapacity();
      }
      // cast crop
      if (storage[3] > _getGranaryCapacity()) {
        storage[3] = _getGranaryCapacity();
      }
    }
  }

  double _getWarehouseCapacity() => 2000;

  double _getGranaryCapacity() => 2000;

  /// Converting a BuildingRecord to a map representation.
  Map<String, dynamic> toMap() => <String, dynamic>{
        '_id': id,
        'name': name,
        'userId': userId,
        'storage': storage,
        'buildings': buildings.map((b) => b.toMap()).toList(),
        'army': army.map((a) => a).toList(),
        'constructionTasks': constructionTasks.map((c) => c.toMap()).toList(),
        'combatUnitQueue': combatUnitQueue.map((c) => c.toMap()).toList(),
        'lastModified': lastModified,
      };

  /// Converting a Settlement to a ResponseBody representation.
  Map<String, dynamic> toResponseBody() => <String, dynamic>{
        'id': id.$oid,
        'name': name,
        'userId': userId,
        'storage': storage,
        'buildings': buildings.map((b) => b.toMap()).toList(),
        'army': army.map((a) => a).toList(),
        'constructionTasks':
            constructionTasks.map((c) => c.toResponseBody()).toList(),
        'combatUnitQueue':
            combatUnitQueue.map((c) => c.toResponseBody()).toList(),
        'lastModified': lastModified.toIso8601String(),
      };

  /// Returns a new `Settlement` instance with the specified updates.
  Settlement copyWith({
    ObjectId? id,
    String? name,
    String? userId,
    List<double>? storage,
    List<BuildingRecord>? buildings,
    List<int>? army,
    List<ConstructionTask>? constructionTasks,
    List<CombatUtitQueue>? combatUnitQueue,
    DateTime? lastModified,
  }) {
    return Settlement(
      id: id ?? this.id,
      name: name ?? this.name,
      userId: userId ?? this.userId,
      storage: storage ?? this.storage,
      buildings: buildings ?? this.buildings,
      army: army ?? this.army,
      constructionTasks: constructionTasks ?? this.constructionTasks,
      combatUnitQueue: combatUnitQueue ?? this.combatUnitQueue,
      lastModified: lastModified ?? this.lastModified,
    );
  }
}

/// The `BuildingRecord` class is used to create records
/// for buildings in Settlement class
class BuildingRecord {
  /// Creates a new `BuildingRecord` with the specified `id` and `level`.
  const BuildingRecord({required this.id, required this.level});

  /// Creates a new `BuildingRecord` from a map representation.
  BuildingRecord.fromMap(Map<String, dynamic> map)
      : id = map['id'] as int,
        level = map['level'] as int;

  /// The unique identifier for the building type.
  final int id;

  /// The current level of the building.
  final int level;

  /// Converting a BuildingRecord to a map representation.
  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'level': level,
      };

  /// Returns a new `BuildingRecord` instance with the specified updates.
  BuildingRecord copyWith({int? id, int? level}) {
    return BuildingRecord(id: id ?? this.id, level: level ?? this.level);
  }
}
