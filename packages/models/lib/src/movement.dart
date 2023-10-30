import 'package:mongo_dart/mongo_dart.dart';

class Movement {
  final ObjectId id;
  final String from;
  final String to;
  final DateTime when;
  final List<int> units;

  Movement(
      {required this.id,
      required this.from,
      required this.to,
      required this.when,
      this.units = const [0,5,0,0,0,0,0,0,0,0]});

  Movement.fromMap(Map<String, dynamic> map)
      : id = map['_id'] as ObjectId,
        from = map['from'] as String,
        to = map['to'] as String,
        when = map['when'] as DateTime,
        units = (map['units'] as List<dynamic>).map((u) => u as int).toList();

  Map<String, dynamic> toMap() => <String, dynamic>{
        '_id': id,
        'from': from,
        'to': to,
        'when': when,
        'units': units,
      };

  Movement copyWith({
    ObjectId? id,
    String? from,
    String? to,
    DateTime? when,
    List<int>? units,
  }) {
    return Movement(
      id: id ?? this.id,
      from: from ?? this.from,
      to: to ?? this.to,
      when: when ?? this.when,
      units: units ?? this.units,
    );
  }

  @override
  String toString() =>
      'Movement(id: $id, from: $from, to: $to, when: $when, units: $units)';
}
