import 'package:models/models.dart';
import 'package:mongo_dart/mongo_dart.dart';

class ReportEntity {
  final ObjectId? id;
  final List<String> reportOwners;
  final List<int> state; // 0 - unread, 1 - read, 2 - deleted
  final Mission mission;
  final PlayerInfo off;
  final List<PlayerInfo> def;
  final DateTime dateTime;

  ReportEntity({
    this.id,
    this.reportOwners = const [],
    this.state = const [],
    required this.mission,
    required this.off,
    required this.def,
    required this.dateTime,
  });

  ReportEntity.fromMap(Map<String, dynamic> map)
      : id = map['_id'] as ObjectId,
        reportOwners = (map['reportOwners'] as List<dynamic>)
            .map((r) => r as String)
            .toList(),
        state = (map['state'] as List<dynamic>)
            .map((s) => s as int)
            .toList(),
        mission = Mission.values.byName(map['mission'] as String),
        off = PlayerInfo.fromMap(map['off'] as Map<String, dynamic>),
        def = (map['def'] as List<dynamic>)
            .map((e) => PlayerInfo.fromMap(e as Map<String, dynamic>))
            .toList(),
        dateTime = map['dateTime'] as DateTime;

  ReportEntity.fromJson(Map<String, dynamic> map)
      : id = ObjectId.parse(map['_id'] as String),
        reportOwners = (map['reportOwners'] as List<dynamic>)
            .map((r) => r as String)
            .toList(),
        state = (map['state'] as List<dynamic>)
            .map((s) => s as int)
            .toList(),
        mission = Mission.values.byName(map['mission'] as String),
        off = PlayerInfo.fromMap(map['off'] as Map<String, dynamic>),
        def = (map['def'] as List<dynamic>)
            .map((e) => PlayerInfo.fromMap(e as Map<String, dynamic>))
            .toList(),
        dateTime = DateTime.parse(map['dateTime'] as String);

  Map<String, dynamic> toMap() => <String, dynamic>{
        '_id': id,
        'reportOwners': reportOwners,
        'state': state,
        'mission': mission.name,
        'off': off.toMap(),
        'def': def.map((d) => d.toMap()).toList(),
        'dateTime': dateTime,
      };

  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'reportOwners': reportOwners,
    'state': state,
    'mission': mission.name,
    'off': off.toMap(),
    'def': def.map((d) => d.toMap()).toList(),
    'dateTime': dateTime.toIso8601String(),
  };

  ReportEntity copyWith({
    ObjectId? id,
    List<String>? reportOwners,
    List<int>? state,
    Mission? mission,
    PlayerInfo? off,
    List<PlayerInfo>? def,
    DateTime? dateTime,
  }) {
    return ReportEntity(
      id: id ?? this.id,
      reportOwners: reportOwners ?? this.reportOwners,
      state: state ?? this.state,
      mission: mission ?? this.mission,
      off: off ?? this.off,
      def: def ?? this.def,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}
