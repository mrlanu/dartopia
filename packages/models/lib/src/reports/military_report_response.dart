import 'package:models/models.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MilitaryReportResponse {
  final ObjectId? id;
  final bool failed;
  final Mission mission;
  final PlayerInfo? off;
  final PlayerInfo? def;
  final List<PlayerInfo> reinforcements;
  final DateTime dateTime;

  MilitaryReportResponse({
    this.id,
    this.failed = false,
    required this.mission,
    this.off,
    this.def,
    this.reinforcements = const [],
    required this.dateTime,
  });

  factory MilitaryReportResponse.full(ReportEntity reportEntity) {
    return MilitaryReportResponse(
      id: reportEntity.id,
      off: reportEntity.off,
      def: reportEntity.def[0],
      reinforcements: List.from(reportEntity.def.sublist(1)),
      mission: reportEntity.mission,
      dateTime: reportEntity.dateTime,
    );
  }

  factory MilitaryReportResponse.failed(ReportEntity reportEntity) {
    return MilitaryReportResponse(
      id: reportEntity.id,
      failed: true,
      off: reportEntity.off,
      mission: reportEntity.mission,
      dateTime: reportEntity.dateTime,
    );
  }

  factory MilitaryReportResponse.reinforcement(
      ReportEntity reportEntity, int index) {
    return MilitaryReportResponse(
      id: reportEntity.id,
      reinforcements: [reportEntity.def[index + 1]],
      mission: reportEntity.mission,
      dateTime: reportEntity.dateTime,
    );
  }

  MilitaryReportResponse.fromMap(Map<String, dynamic> map)
      : id = map['_id'] as ObjectId,
        failed = map['failed'] as bool,
        mission = Mission.values.byName(map['mission'] as String),
        off = map.containsKey('off') && map['off'] != null
            ? PlayerInfo.fromMap(map['off'] as Map<String, dynamic>)
            : null,
        def = map.containsKey('def') && map['def'] != null
            ? PlayerInfo.fromMap(map['def'] as Map<String, dynamic>)
            : null,
        reinforcements = (map['reinforcements'] as List<dynamic>)
            .map((e) => PlayerInfo.fromMap(e as Map<String, dynamic>))
            .toList(),
        dateTime = map['dateTime'] as DateTime;

  MilitaryReportResponse.fromJson(Map<String, dynamic> map)
      : id = ObjectId.parse(map['_id'] as String),
        failed = map['failed'] as bool,
        mission = Mission.values.byName(map['mission'] as String),
        off = map.containsKey('off') && map['off'] != null
            ? PlayerInfo.fromMap(map['off'] as Map<String, dynamic>)
            : null,
        def = map.containsKey('def') && map['def'] != null
            ? PlayerInfo.fromMap(map['def'] as Map<String, dynamic>)
            : null,
        reinforcements = (map['reinforcements'] as List<dynamic>)
            .map((e) => PlayerInfo.fromMap(e as Map<String, dynamic>))
            .toList(),
        dateTime = DateTime.parse(map['dateTime'] as String);

  Map<String, dynamic> toMap() => <String, dynamic>{
        '_id': id,
        'failed': failed,
        'mission': mission.name,
        'off': off?.toMap(),
        'def': off?.toMap(),
        'reinforcements': reinforcements.map((d) => d.toMap()).toList(),
        'dateTime': dateTime,
      };

  Map<String, dynamic> toJson() => <String, dynamic>{
        '_id': id,
        'failed': failed,
        'mission': mission.name,
        'off': off?.toMap(),
        'def': def?.toMap(),
        'reinforcements': reinforcements.map((d) => d.toMap()).toList(),
        'dateTime': dateTime.toIso8601String(),
      };

  MilitaryReportResponse copyWith({
    ObjectId? id,
    bool? failed,
    Mission? mission,
    PlayerInfo? off,
    PlayerInfo? def,
    List<PlayerInfo>? reinforcements,
    DateTime? dateTime,
  }) {
    return MilitaryReportResponse(
      id: id ?? this.id,
      failed: failed ?? this.failed,
      mission: mission ?? this.mission,
      off: off ?? this.off,
      def: def ?? this.def,
      reinforcements: reinforcements ?? this.reinforcements,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}
