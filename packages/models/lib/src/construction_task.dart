class ConstructionTask {
  final String id;
  final int position;
  final int toLevel;
  final DateTime when;

  ConstructionTask({required this.id,
    required this.position,
    required this.toLevel,
    required this.when});

  ConstructionTask.fromMap(Map<String, dynamic> map)
      : id = map['id'] as String,
        position = map['position'] as int,
        toLevel = map['toLevel'] as int,
        when = map['when'] as DateTime;

  Map<String, dynamic> toMap() =>
      <String, dynamic>{
        'id': id,
        'position': position,
        'toLevel': toLevel,
        'when': when,
      };

  ConstructionTask copyWith({
    String? id,
    int? position,
    int? toLevel,
    DateTime? when,
  }) {
    return ConstructionTask(id: id ?? this.id,
        position: position ?? this.position,
        toLevel: toLevel ?? this.toLevel,
        when: when ?? this.when,);
  }
}
