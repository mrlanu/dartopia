import 'package:models/src/construction_task.dart';
import 'package:mongo_dart/mongo_dart.dart';

class Settlement {
  Settlement({
    required this.id,
    required this.userId,
    this.name = 'New village',
    this.resources = const [500.0, 500.0, 500.0, 500.0],
    this.buildings = const [
      BuildingRecord(id: 1, level: 1),
      BuildingRecord(id: 2, level: 1),
      BuildingRecord(id: 3, level: 1),
      BuildingRecord(id: 4, level: 1),
      BuildingRecord(id: 5, level: 1),
    ],
    this.constructionTasks = const [],
    DateTime? lastModified,
  }) : lastModified = lastModified ?? DateTime.now();

  ObjectId id;
  final String userId;
  String name;
  List<double> resources;

  List<BuildingRecord> buildings;

  List<ConstructionTask> constructionTasks;
  DateTime lastModified;

  /// The method calculates the production of wood, clay, iron, and crop resources
  /// over a specified duration and updates the resource storage with the new values.
  void calculateProducedGoods({DateTime? toDateTime}) {
    toDateTime ??= DateTime.now();
    final producePerHour = _producePerHour();
    final durationSinceLastModified =
        toDateTime.difference(lastModified).inSeconds;
    final divider = durationSinceLastModified / 3600;
    final woodProduced = producePerHour[0] * divider;
    final clayProduced = producePerHour[1] * divider;
    final ironProduced = producePerHour[2] * divider;
    final cropProduced = producePerHour[3] * divider;
    final newStorage = [
      double.parse((resources[0] + woodProduced).toStringAsFixed(4)),
      double.parse((resources[1] + clayProduced).toStringAsFixed(4)),
      double.parse((resources[2] + ironProduced).toStringAsFixed(4)),
      double.parse((resources[3] + cropProduced).toStringAsFixed(4)),
    ];
    resources = newStorage;
  }

  List<double> _producePerHour() {
    return [60.0, 60.0, 60.0, 60.0];
  }

  Settlement.fromMap(Map<String, dynamic> map)
      : id = map['_id'] as ObjectId,
        name = map['name'] as String,
        userId = map['userId'] as String,
        resources = (map['resources'] as List<dynamic>)
            .map((e) => (e as num).toDouble())
            .toList(),
        buildings = (map['buildings'] as List<dynamic>)
            .map((e) => BuildingRecord.fromMap(e as Map<String, dynamic>))
            .toList(),
        constructionTasks = (map['constructionTasks'] as List<dynamic>)
            .map((e) => ConstructionTask.fromMap(e as Map<String, dynamic>))
            .toList(),
        lastModified = map['lastModified'] as DateTime;

  Map<String, dynamic> toMap() => <String, dynamic>{
        '_id': id,
        'name': name,
        'userId': userId,
        'resources': resources,
        'buildings': buildings.map((b) => b.toMap()).toList(),
        'constructionTasks': constructionTasks.map((c) => c.toMap()).toList(),
        'lastModified': lastModified,
      };

  Map<String, dynamic> toResponseBody() => <String, dynamic>{
        'id': id.$oid,
        'name': name,
        'userId': userId,
        'resources': resources,
        'buildings': buildings.map((b) => b.toMap()).toList(),
        'constructionTasks': constructionTasks.map((c) => c.toMap()).toList(),
        'lastModified': lastModified,
      };

  Settlement copyWith({
    ObjectId? id,
    String? name,
    String? userId,
    List<double>? resources,
    List<BuildingRecord>? buildings,
    List<ConstructionTask>? constructionTasks,
    DateTime? lastModified,
  }) {
    return Settlement(
      id: id ?? this.id,
      name: name ?? this.name,
      userId: userId ?? this.userId,
      resources: resources ?? this.resources,
      buildings: buildings ?? this.buildings,
      constructionTasks: constructionTasks ?? this.constructionTasks,
      lastModified: lastModified ?? this.lastModified,
    );
  }
}

class BuildingRecord {
  final int id;
  final int level;

  const BuildingRecord({required this.id, required this.level});

  BuildingRecord.fromMap(Map<String, dynamic> map)
      : id = map['id'] as int,
        level = map['level'] as int;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'level': level,
      };

  BuildingRecord copyWith({int? id, int? level}) {
    return BuildingRecord(id: id ?? this.id, level: level ?? this.level);
  }
}
