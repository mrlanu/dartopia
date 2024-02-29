import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

import 'package:mongo_dart/mongo_dart.dart';

/// The `Settlement` class
class Settlement extends Equatable {
  /// Creates a new `Settlement`.
  Settlement({
    required this.id,
    required this.userId,
    required this.x,
    required this.y,
    this.name = 'New village',
    this.storage = const [500.0, 500.0, 500.0, 500.0],
    this.buildings = const [
      //------------------FIELDS----------------
      [0, 0, 0],
      [1, 0, 0],
      [2, 0, 1],
      [3, 0, 0],
      // lumber
      [4, 1, 0],
      [5, 1, 0],
      [6, 1, 1],
      [7, 1, 0],
      // clay
      [8, 2, 0],
      [9, 2, 0],
      [10, 2, 1],
      [11, 2, 0],
      // iron
      [12, 3, 0],
      [13, 3, 0],
      [14, 3, 0],
      [15, 3, 1],
      [16, 3, 0],
      [17, 3, 0],
      // crop
      //------------------BUILDINGS----------------
      [18, 4, 1],
      [19, 99, 0],
      [20, 99, 0],
      [21, 99, 0],
      [22, 99, 0],
      [23, 99, 0],
      [24, 99, 0],
    ],
    this.units = const [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    this.constructionTasks = const [],
    this.combatUnitQueue = const [],
    DateTime? lastModified,
  }) : lastModified = lastModified ?? DateTime.now();

  Settlement.fromMap(Map<String, dynamic> map)
      : id = map['_id'] as ObjectId,
        name = map['name'] as String,
        x = map['x'] as int,
        y = map['y'] as int,
        userId = map['userId'] as String,
        storage = (map['storage'] as List<dynamic>)
            .map((e) => (e as num).toDouble())
            .toList(),
        buildings = (map['buildings'] as List<dynamic>)
            .map(
              (b) => (b as List<dynamic>).map((e) => e as int).toList(),
            )
            .toList(),
        units = (map['army'] as List<dynamic>).map((e) => e as int).toList(),
        constructionTasks = (map['constructionTasks'] as List<dynamic>)
            .map((e) => ConstructionTask.fromMap(e as Map<String, dynamic>))
            .toList(),
        combatUnitQueue = (map['combatUnitQueue'] as List<dynamic>)
            .map((e) => CombatUtitQueue.fromMap(e as Map<String, dynamic>))
            .toList(),
        lastModified = map['lastModified'] as DateTime;

  Settlement.fromJson(Map<String, dynamic> map)
      : id = ObjectId.parse(map['_id'] as String),
        name = map['name'] as String,
        x = map['x'] as int,
        y = map['y'] as int,
        userId = map['userId'] as String,
        storage = (map['storage'] as List<dynamic>)
            .map((e) => (e as num).toDouble())
            .toList(),
        buildings = (map['buildings'] as List<dynamic>)
            .map(
              (b) => (b as List<dynamic>).map((e) => e as int).toList(),
            )
            .toList(),
        units = (map['army'] as List<dynamic>).map((e) => e as int).toList(),
        constructionTasks = (map['constructionTasks'] as List<dynamic>)
            .map((e) => ConstructionTask.fromJson(e as Map<String, dynamic>))
            .toList(),
        combatUnitQueue = (map['combatUnitQueue'] as List<dynamic>)
            .map((e) => CombatUtitQueue.fromMap(e as Map<String, dynamic>))
            .toList(),
        lastModified = DateTime.parse(map['lastModified'] as String);

  ObjectId id;
  final String userId;
  String name;
  int x;
  int y;
  List<double> storage;
  List<List<int>> buildings;
  List<int> units;
  List<ConstructionTask> constructionTasks;
  List<CombatUtitQueue> combatUnitQueue;
  DateTime lastModified;

  /// Return just empty spots
  List<List<int>> get emptySpots =>
      buildings.where((bR) => bR[1] == 99).toList();

  /// Return just buildings without fields
  List<List<int>> get buildingsExceptFields => buildings
      .where((bR) => bR[1] != 0 && bR[1] != 1 && bR[1] != 2 && bR[1] != 3)
      .toList();

  /// Return just buildings without fields and empty spots
  List<List<int>> get buildingsExceptFieldsAndEmpty => buildings
      .where((bR) =>
          bR[1] != 99 && bR[1] != 0 && bR[1] != 1 && bR[1] != 2 && bR[1] != 3)
      .toList();

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
          (b) => b[1] == 0 || b[1] == 1 || b[1] == 2 || b[1] == 3,
        )
        .toList();

    // Group the filtered buildings by `id`.
    final groupedBuildings = groupBy(
      resourceBuilding,
      (List<int> b) => b[1],
    );

    // Calculate the total production for each building type.
    final reducedMap = groupedBuildings.map((key, value) {
      final sum = value.fold(0, (a, b) {
        final benefit = buildingSpecefication[key]!.benefit(b[2]);
        return a + benefit.toInt();
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
      if (storage[i] > getMaxCapacity(6)) {
        storage[i] = getMaxCapacity(6);
      }
      // cast crop
      if (storage[3] > getMaxCapacity(5)) {
        storage[3] = getMaxCapacity(5);
      }
    }
  }

  double getMaxCapacity(int buildingId) {
    final storages = buildings
        .where((b) => b[1] == buildingId)
        .map((e) => buildingSpecefication[6]!.benefit(e[2]))
        .toList();
    return storages.isEmpty ? 800 : storages.reduce((a, b) => a + b);
  }

  /// Subtract given amount of each resource from the Settlement's storage
  void spendResources(List<int> resources) {
    final result = <double>[];
    for (var i = 0; i < storage.length; i++) {
      result.add(storage[i] - resources[i]);
    }
    storage = result;
  }

  /// Changing the BuildingRecord on given position.
  void changeBuilding(
      {required int position, required int buildingId, required int level}) {
    buildings[position] = [position, buildingId, level];
  }

  /// Converting a BuildingRecord to a map representation.
  Map<String, dynamic> toMap() => <String, dynamic>{
        '_id': id,
        'name': name,
        'x': x,
        'y': y,
        'userId': userId,
        'storage': storage,
        'buildings': buildings,
        'army': units.map((a) => a).toList(),
        'constructionTasks': constructionTasks.map((c) => c.toMap()).toList(),
        'combatUnitQueue': combatUnitQueue.map((c) => c.toMap()).toList(),
        'lastModified': lastModified,
      };

  /// Converting a Settlement to a ResponseBody representation.
  Map<String, dynamic> toJson() => <String, dynamic>{
        '_id': id,
        'name': name,
        'x': x,
        'y': y,
        'userId': userId,
        'storage': storage,
        'buildings': buildings,
        'army': units.map((a) => a).toList(),
        'constructionTasks': constructionTasks.map((c) => c.toJson()).toList(),
        'combatUnitQueue': combatUnitQueue.map((c) => c.toJson()).toList(),
        'lastModified': lastModified.toIso8601String(),
      };

  /// Returns a new `Settlement` instance with the specified updates.
  Settlement copyWith({
    ObjectId? id,
    String? name,
    int? x,
    int? y,
    String? userId,
    List<double>? storage,
    List<List<int>>? buildings,
    List<int>? units,
    List<ConstructionTask>? constructionTasks,
    List<CombatUtitQueue>? combatUnitQueue,
    DateTime? lastModified,
  }) {
    return Settlement(
      id: id ?? this.id,
      name: name ?? this.name,
      x: x ?? this.x,
      y: y ?? this.y,
      userId: userId ?? this.userId,
      storage: storage ?? this.storage,
      buildings: buildings ?? this.buildings,
      units: units ?? this.units,
      constructionTasks: constructionTasks ?? this.constructionTasks,
      combatUnitQueue: combatUnitQueue ?? this.combatUnitQueue,
      lastModified: lastModified ?? this.lastModified,
    );
  }

  @override
  List<Object?> get props => [id, storage, buildings, constructionTasks];
}
