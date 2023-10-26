import 'package:mongo_dart/mongo_dart.dart';

class Movement {
  final ObjectId id;
  final String from;
  final String to;
  final DateTime when;

  Movement({required this.id, required this.from, required this.to, required this.when});


  Movement.fromMap(Map<String, dynamic> map)
      : id = map['_id'] as ObjectId,
        from = map['from'] as String,
        to = map['to'] as String,
        when = map['when'] as DateTime;

  Map<String, dynamic> toMap() => <String, dynamic>{
    '_id': id,
    'from': from,
    'to': to,
    'when': when,
  };

  Movement copyWith({
    ObjectId? id,
    String? from,
    String? to,
    DateTime? when,
}){
    return Movement(
      id: id ?? this.id,
      from: from ?? this.from,
      to: to ?? this.to,
      when: when ?? this.when,
    );
  }

  @override
  String toString() => 'Movement(id: $id, from: $from, to: $to, when: $when)';
}
