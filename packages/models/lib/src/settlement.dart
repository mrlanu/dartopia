import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:models/models.dart';
import 'package:mongo_dart/mongo_dart.dart';

/// The `Settlement` class
class Settlement extends Equatable {
  /// Creates a new `Settlement`.
  Settlement({
    required this.id,
    this.kind = SettlementKind.six,
    required this.userId,
    required this.nation,
    required this.x,
    required this.y,
    this.name = 'New village',
    this.storage = const [500.0, 500.0, 500.0, 500.0],
    this.buildings = const [
      //------------------FIELDS----------------
      [0, 0, 0, 0], // [position, id, level, canBeUpgraded]
      [1, 0, 0, 0],
      [2, 0, 1, 0],
      [3, 0, 0, 0],
      // lumber
      [4, 1, 0, 0],
      [5, 1, 0, 0],
      [6, 1, 1, 0],
      [7, 1, 0, 0],
      // clay
      [8, 2, 0, 0],
      [9, 2, 0, 0],
      [10, 2, 1, 0],
      [11, 2, 0, 0],
      // iron
      [12, 3, 0, 0],
      [13, 3, 0, 0],
      [14, 3, 0, 0],
      [15, 3, 1, 0],
      [16, 3, 0, 0],
      [17, 3, 0, 0],
      // crop
      //------------------BUILDINGS----------------
      [18, 4, 1, 0],
    ],
    this.units = const [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    this.movements = const [],
    this.constructionTasks = const [],
    this.availableUnits = const [0],
    this.combatUnitQueue = const [],
    DateTime? lastModified,
    DateTime? lastSpawnedAnimals,
  })  : lastModified = lastModified ?? DateTime.now(),
        lastSpawnedAnimals = lastSpawnedAnimals ?? DateTime.now();

  Settlement.fromMap(Map<String, dynamic> map)
      : id = map['_id'] as ObjectId,
        kind = SettlementKind.values.byName(map['kind'] as String),
        name = map['name'] as String,
        x = map['x'] as int,
        y = map['y'] as int,
        userId = map['userId'] as String,
        nation = Nations.values.byName(map['nation'] as String),
        storage = (map['storage'] as List<dynamic>)
            .map((e) => (e as num).toDouble())
            .toList(),
        buildings = (map['buildings'] as List<dynamic>)
            .map(
              (b) => (b as List<dynamic>).map((e) => e as int).toList(),
            )
            .toList(),
        units = (map['army'] as List<dynamic>).map((e) => e as int).toList(),
        movements = (map['movements'] as List<dynamic>)
            .map((e) => Movement.fromMap(e as Map<String, dynamic>))
            .toList(),
        constructionTasks = (map['constructionTasks'] as List<dynamic>)
            .map((e) => ConstructionTask.fromMap(e as Map<String, dynamic>))
            .toList(),
        availableUnits = (map['availableUnits'] as List<dynamic>)
            .map((e) => e as int)
            .toList(),
        combatUnitQueue = (map['combatUnitQueue'] as List<dynamic>)
            .map((e) => CombatUnitQueue.fromMap(e as Map<String, dynamic>))
            .toList(),
        lastModified = map['lastModified'] as DateTime,
        lastSpawnedAnimals = map['lastSpawnedAnimals'] as DateTime;

  Settlement.fromJson(Map<String, dynamic> map)
      : id = ObjectId.parse(map['_id'] as String),
        kind = SettlementKind.values.byName(map['kind'] as String),
        name = map['name'] as String,
        x = map['x'] as int,
        y = map['y'] as int,
        userId = map['userId'] as String,
        nation = Nations.values.byName(map['nation'] as String),
        storage = (map['storage'] as List<dynamic>)
            .map((e) => (e as num).toDouble())
            .toList(),
        buildings = (map['buildings'] as List<dynamic>)
            .map(
              (b) => (b as List<dynamic>).map((e) => e as int).toList(),
            )
            .toList(),
        units = (map['army'] as List<dynamic>).map((e) => e as int).toList(),
        movements = (map['movements'] as List<dynamic>)
            .map((e) => Movement.fromJson(e as Map<String, dynamic>))
            .toList(),
        constructionTasks = (map['constructionTasks'] as List<dynamic>)
            .map((e) => ConstructionTask.fromJson(e as Map<String, dynamic>))
            .toList(),
        availableUnits = (map['availableUnits'] as List<dynamic>)
            .map((e) => e as int)
            .toList(),
        combatUnitQueue = (map['combatUnitQueue'] as List<dynamic>)
            .map((e) => CombatUnitQueue.fromJson(e as Map<String, dynamic>))
            .toList(),
        lastModified = DateTime.parse(map['lastModified'] as String),
        lastSpawnedAnimals =
            DateTime.parse(map['lastSpawnedAnimals'] as String);

  final ObjectId id;
  final SettlementKind kind;
  final String userId;
  final Nations nation;
  String name;
  final int x;
  final int y;
  List<double> storage;
  final List<List<int>> buildings;
  List<int> units;
  final List<Movement> movements;
  final List<ConstructionTask> constructionTasks;
  final List<int> availableUnits;
  List<CombatUnitQueue> combatUnitQueue;
  DateTime lastModified;
  DateTime lastSpawnedAnimals;

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
  void addCombatUnitOrder(CombatUnitQueue order) {
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

  /// Add the BuildingRecord to the end of buildings list.
  void addConstruction(
      {required int buildingId,
      required int specificationId,
      required int level}) {
    buildings.add([buildingId, specificationId, level, 0]);
  }

  /// Changing the BuildingRecord on given position.
  int changeBuilding({
    required int buildingId,
    required int specificationId,
    required int level,
  }) {
    var index = -1;
    for (var i = 0; i < buildings.length; i++) {
      if (buildings[i][0] == buildingId) {
        index = i;
        break;
      }
    }
    buildings[index] = [buildingId, specificationId, level, 0];
    return buildingSpecefication[specificationId]!.getPopulation(level);
  }

  /// Converting a BuildingRecord to a map representation.
  Map<String, dynamic> toMap() => <String, dynamic>{
        '_id': id,
        'kind': kind.name,
        'name': name,
        'x': x,
        'y': y,
        'userId': userId,
        'nation': nation.name,
        'storage': storage,
        'buildings': buildings,
        'army': units.map((a) => a).toList(),
        'movements': movements.map((m) => m.toMap()).toList(),
        'constructionTasks': constructionTasks.map((c) => c.toMap()).toList(),
        'availableUnits': availableUnits.map((u) => u).toList(),
        'combatUnitQueue': combatUnitQueue.map((c) => c.toMap()).toList(),
        'lastModified': lastModified,
        'lastSpawnedAnimals': lastSpawnedAnimals,
      };

  /// Converting a Settlement to a ResponseBody representation.
  Map<String, dynamic> toJson() => <String, dynamic>{
        '_id': id,
        'kind': kind.name,
        'name': name,
        'x': x,
        'y': y,
        'userId': userId,
        'nation': nation.name,
        'storage': storage,
        'buildings': buildings,
        'army': units.map((a) => a).toList(),
        'movements': movements.map((m) => m.toJson()).toList(),
        'constructionTasks': constructionTasks.map((c) => c.toJson()).toList(),
        'availableUnits': availableUnits.map((u) => u).toList(),
        'combatUnitQueue': combatUnitQueue.map((c) => c.toJson()).toList(),
        'lastModified': lastModified.toIso8601String(),
        'lastSpawnedAnimals': lastSpawnedAnimals.toIso8601String(),
      };

  /// Returns a new `Settlement` instance with the specified updates.
  Settlement copyWith({
    ObjectId? id,
    SettlementKind? kind,
    String? name,
    int? x,
    int? y,
    String? userId,
    Nations? nation,
    List<double>? storage,
    List<List<int>>? buildings,
    List<int>? units,
    List<Movement>? movements,
    List<ConstructionTask>? constructionTasks,
    List<int>? availableUnits,
    List<CombatUnitQueue>? combatUnitQueue,
    DateTime? lastModified,
    DateTime? lastSpawnedAnimals,
  }) {
    return Settlement(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      name: name ?? this.name,
      x: x ?? this.x,
      y: y ?? this.y,
      userId: userId ?? this.userId,
      nation: nation ?? this.nation,
      storage: storage ?? this.storage,
      buildings: buildings ?? this.buildings,
      units: units ?? this.units,
      movements: movements ?? this.movements,
      constructionTasks: constructionTasks ?? this.constructionTasks,
      availableUnits: availableUnits ?? this.availableUnits,
      combatUnitQueue: combatUnitQueue ?? this.combatUnitQueue,
      lastModified: lastModified ?? this.lastModified,
      lastSpawnedAnimals: lastSpawnedAnimals ?? this.lastSpawnedAnimals,
    );
  }

  @override
  List<Object?> get props =>
      [id, storage, buildings, constructionTasks, movements];

  void reorderBuildings(List<List<int>> newBuildings) {
    for (var i = 0; i < buildings.length; i++) {
      buildings[i] = newBuildings[i];
    }
  }
}
