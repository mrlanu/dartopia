import 'package:equatable/equatable.dart';
import 'package:models/models.dart';
import 'package:mongo_dart/mongo_dart.dart';

class ConstructionTask extends Equatable implements Executable {
  final String id;
  final int specificationId;
  final int buildingId;
  final int toLevel;
  final DateTime when;

  ConstructionTask(
      {String? id,
      required this.specificationId,
      required this.buildingId,
      required this.toLevel,
      required this.when})
      : id = id ?? const Uuid().v4();

  ConstructionTask.fromMap(Map<String, dynamic> map)
      : id = map['id'] as String,
        specificationId = map['specificationId'] as int,
        buildingId = map['buildingId'] as int,
        toLevel = map['toLevel'] as int,
        when = map['when'] as DateTime;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'specificationId': specificationId,
        'buildingId': buildingId,
        'toLevel': toLevel,
        'when': when,
      };

  ConstructionTask.fromJson(Map<String, dynamic> map)
      : id = map['id'] as String,
        specificationId = map['specificationId'] as int,
        buildingId = map['buildingId'] as int,
        toLevel = map['toLevel'] as int,
        when = DateTime.parse(map['when'] as String);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'specificationId': specificationId,
        'buildingId': buildingId,
        'toLevel': toLevel,
        'when': when.toIso8601String(),
      };

  ConstructionTask copyWith({
    String? id,
    int? specificationId,
    int? buildingId,
    int? toLevel,
    DateTime? when,
  }) {
    return ConstructionTask(
      id: id ?? this.id,
      specificationId: buildingId ?? this.specificationId,
      buildingId: buildingId ?? this.buildingId,
      toLevel: toLevel ?? this.toLevel,
      when: when ?? this.when,
    );
  }

  @override
  int execute(Settlement settlement) {
    // upgrade building
    final statPoints = settlement.changeBuilding(
      buildingId: buildingId,
      specificationId: specificationId,
      level: toLevel,
    );
    // remove executed Task
    settlement.constructionTasks.remove(this);
    return statPoints;
  }

  @override
  DateTime get executionTime => when;

  @override
  List<Object?> get props => [id, when];
}
