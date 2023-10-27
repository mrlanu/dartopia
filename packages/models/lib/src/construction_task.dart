import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

class ConstructionTask extends Equatable implements Executable {
  final String id;
  final int position;
  final int toLevel;
  final DateTime when;

  ConstructionTask(
      {required this.id,
      required this.position,
      required this.toLevel,
      required this.when});

  ConstructionTask.fromMap(Map<String, dynamic> map)
      : id = map['id'] as String,
        position = map['position'] as int,
        toLevel = map['toLevel'] as int,
        when = map['when'] as DateTime;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'position': position,
        'toLevel': toLevel,
        'when': when,
      };

  Map<String, dynamic> toResponseBody() => <String, dynamic>{
        'id': id,
        'position': position,
        'toLevel': toLevel,
        'when': when.toIso8601String(),
      };

  ConstructionTask copyWith({
    String? id,
    int? position,
    int? toLevel,
    DateTime? when,
  }) {
    return ConstructionTask(
      id: id ?? this.id,
      position: position ?? this.position,
      toLevel: toLevel ?? this.toLevel,
      when: when ?? this.when,
    );
  }

  @override
  void execute(Settlement settlement) {
    print('Inside Construction task execute method.');
    // upgrade building
    settlement.buildings[position] =
        settlement.buildings[position].copyWith(level: toLevel);
    // remove executed Task
    settlement.constructionTasks.remove(this);
  }

  @override
  DateTime get executionTime => when;

  @override
  List<Object?> get props => [id, when];
}
