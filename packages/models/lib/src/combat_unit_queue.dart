import 'package:equatable/equatable.dart';
import 'package:mongo_dart/mongo_dart.dart';

class CombatUnitQueue extends Equatable{
  final String id;
  DateTime lastTime;
  final int unitId;
  int leftTrain;
  final int durationEach;

  CombatUnitQueue(
      {String? id,
      required this.lastTime,
      required this.unitId,
      required this.leftTrain,
      required this.durationEach})
      : id = id ?? Uuid().v4();

  CombatUnitQueue.fromMap(Map<String, dynamic> map)
      : id = map['id'] as String,
        lastTime = map['lastTime'] as DateTime,
        unitId = map['unitId'] as int,
        leftTrain = map['leftTrain'] as int,
        durationEach = map['durationEach'] as int;

  CombatUnitQueue.fromJson(Map<String, dynamic> map)
      : id = map['id'] as String,
        lastTime = DateTime.parse(map['lastTime'] as String),
        unitId = map['unitId'] as int,
        leftTrain = map['leftTrain'] as int,
        durationEach = map['durationEach'] as int;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'lastTime': lastTime,
        'unitId': unitId,
        'leftTrain': leftTrain,
        'durationEach': durationEach,
      };

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'lastTime': lastTime.toIso8601String(),
        'unitId': unitId,
        'leftTrain': leftTrain,
        'durationEach': durationEach,
      };

  CombatUnitQueue copyWith(
      {String? id,
      DateTime? lastTime,
      int? unitId,
      int? leftTrain,
      int? durationEach}) {
    return CombatUnitQueue(
      id: id ?? this.id,
      lastTime: lastTime ?? this.lastTime,
      unitId: unitId ?? this.unitId,
      leftTrain: leftTrain ?? this.leftTrain,
      durationEach: durationEach ?? this.durationEach,
    );
  }

  @override
  List<Object?> get props => [id, lastTime, unitId, leftTrain, durationEach];
}
