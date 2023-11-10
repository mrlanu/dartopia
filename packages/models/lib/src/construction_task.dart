import 'package:equatable/equatable.dart';
import 'package:models/models.dart';
import 'package:mongo_dart/mongo_dart.dart';

class ConstructionTask extends Equatable implements Executable {
  final String id;
  final int buildingId;
  final int position;
  final int toLevel;
  final DateTime when;

  ConstructionTask(
      {String? id,
      required this.buildingId,
      required this.position,
      required this.toLevel,
      required this.when})
      : id = id ?? const Uuid().v4();

  ConstructionTask.fromMap(Map<String, dynamic> map)
      : id = map['id'] as String,
        buildingId = map['buildingId'] as int,
        position = map['position'] as int,
        toLevel = map['toLevel'] as int,
        when = map['when'] as DateTime;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'buildingId': buildingId,
        'position': position,
        'toLevel': toLevel,
        'when': when,
      };

  ConstructionTask.fromJson(Map<String, dynamic> map)
      : id = map['id'] as String,
        buildingId = map['buildingId'] as int,
        position = map['position'] as int,
        toLevel = map['toLevel'] as int,
        when = DateTime.parse(map['when'] as String);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'buildingId': buildingId,
        'position': position,
        'toLevel': toLevel,
        'when': when.toIso8601String(),
      };

  ConstructionTask copyWith({
    String? id,
    int? buildingId,
    int? position,
    int? toLevel,
    DateTime? when,
  }) {
    return ConstructionTask(
      id: id ?? this.id,
      buildingId: buildingId ?? this.buildingId,
      position: position ?? this.position,
      toLevel: toLevel ?? this.toLevel,
      when: when ?? this.when,
    );
  }

  @override
  void execute(Settlement settlement) {
    // upgrade building
    settlement.changeBuilding(
        position: position, buildingId: buildingId, level: toLevel,);
    // remove executed Task
    settlement.constructionTasks.remove(this);
  }

  @override
  DateTime get executionTime => when;

  @override
  List<Object?> get props => [id, when];
}
