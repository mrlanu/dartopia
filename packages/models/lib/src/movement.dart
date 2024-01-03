import 'package:models/models.dart';
import 'package:mongo_dart/mongo_dart.dart';

enum Mission {
  home,
  back,
  caught,
  attack,
  raid,
  reinforcement,
}

class Movement {
  final ObjectId? id;
  final bool isMoving;
  final SideBrief from;
  final SideBrief to;
  final DateTime when;
  final List<int> units;
  final List<int> plunder;
  final Mission mission;
  final Nations nation;

  Movement(
      {this.id,
      this.isMoving = true,
      required this.from,
      required this.to,
      required this.when,
      this.units = const [0, 5, 0, 0, 0, 0, 0, 0, 0, 0],
        this.plunder = const [0, 0, 0, 0],
      required this.mission, this.nation = Nations.gaul});

  Movement.fromMap(Map<String, dynamic> map)
      : id = map['_id'] as ObjectId,
        isMoving = map['isMoving'] as bool,
        from = SideBrief.fromMap(map['from'] as Map<String, dynamic>),
        to = SideBrief.fromMap(map['to'] as Map<String, dynamic>),
        when = map['when'] as DateTime,
        units = (map['units'] as List<dynamic>).map((u) => u as int).toList(),
        plunder = (map['plunder'] as List<dynamic>).map((u) => u as int).toList(),
        mission = Mission.values.byName(map['mission'] as String),
        nation = Nations.values.byName(map['nation'] as String);

  Movement.fromJson(Map<String, dynamic> map)
      : id = ObjectId.parse(map['_id'] as String),
        isMoving = map['isMoving'] as bool,
        from = SideBrief.fromJson(map['from'] as Map<String, dynamic>),
        to = SideBrief.fromJson(map['to'] as Map<String, dynamic>),
        when = DateTime.parse(map['when'] as String),
        units = (map['units'] as List<dynamic>).map((u) => u as int).toList(),
        plunder = (map['plunder'] as List<dynamic>).map((u) => u as int).toList(),
        mission = Mission.values.byName(map['mission'] as String),
        nation = Nations.values.byName(map['nation'] as String);

  Map<String, dynamic> toMap() => <String, dynamic>{
        '_id': id,
        'isMoving': isMoving,
        'from': from.toMap(),
        'to': to.toMap(),
        'when': when,
        'units': units,
        'plunder': plunder,
        'mission': mission.name,
        'nation': nation.name,
      };

  Map<String, dynamic> toJson() => <String, dynamic>{
        '_id': id,
        'isMoving': isMoving,
        'from': from,
        'to': to,
        'when': when.toIso8601String(),
        'units': units,
        'plunder': plunder,
        'mission': mission.name,
        'nation': nation.name,
      };

  Movement copyWith({
    ObjectId? id,
    bool? isMoving,
    SideBrief? from,
    SideBrief? to,
    DateTime? when,
    List<int>? units,
    List<int>? plunder,
    Mission? mission,
    Nations? nation,
  }) {
    return Movement(
      id: id ?? this.id,
      isMoving: isMoving ?? this.isMoving,
      from: from ?? this.from,
      to: to ?? this.to,
      when: when ?? this.when,
      units: units ?? this.units,
      plunder: plunder ?? this.plunder,
      mission: mission ?? this.mission,
      nation: nation ?? this.nation,
    );
  }

  @override
  String toString() =>
      'Movement(id: $id, isMoving: $isMoving, from: $from, to: $to, when: $when, units: $units, mission: ${mission.name})';
}
