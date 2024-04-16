import 'package:collection/collection.dart';
import 'package:models/models.dart';
import 'package:models/src/reports/def_info.dart';

class MilitaryReportResponse {
  final String id;
  final bool failed;
  final Mission mission;
  final PlayerInfo? off;
  final PlayerInfo? def;
  final List<DefenseInfo> reinforcements;
  final DateTime dateTime;
  final List<int> bounty;

  MilitaryReportResponse({
    required this.id,
    required this.failed,
    required this.mission,
    this.off,
    this.def,
    this.reinforcements = const [],
    required this.dateTime,
    required this.bounty,
  });

  factory MilitaryReportResponse.full(ReportEntity reportEntity) {
    return MilitaryReportResponse(
      id: reportEntity.id!,
      off: reportEntity.participants[0],
      def: reportEntity.participants[1],
      reinforcements:
          _groupAndReduceDefence(reportEntity.participants.sublist(2)),
      mission: reportEntity.mission,
      dateTime: reportEntity.dateTime,
      failed: false,
      bounty: reportEntity.bounty,
    );
  }

  factory MilitaryReportResponse.failed(ReportEntity reportEntity) {
    return MilitaryReportResponse(
        id: reportEntity.id!,
        failed: true,
        off: reportEntity.participants[0],
        def: reportEntity.participants[1].copyWith(units: [], casualty: []),
        mission: reportEntity.mission,
        dateTime: reportEntity.dateTime,
        bounty: [0, 0, 0, 0]);
  }

  factory MilitaryReportResponse.reinforcement(
    ReportEntity reportEntity,
    int index,
  ) {
    return MilitaryReportResponse(
      id: reportEntity.id!,
      def: reportEntity.participants[1].copyWith(units: [], casualty: []),
      reinforcements: _groupAndReduceDefence([reportEntity.participants[index]]),
      mission: reportEntity.mission,
      dateTime: reportEntity.dateTime,
      bounty: [0, 0, 0, 0],
      failed: false,
    );
  }

  MilitaryReportResponse.fromMap(Map<String, dynamic> map)
      : id = map['_id'] as String,
        failed = map['failed'] as bool,
        mission = Mission.values.byName(map['mission'] as String),
        off = map.containsKey('off') && map['off'] != null
            ? PlayerInfo.fromMap(map['off'] as Map<String, dynamic>)
            : null,
        def = map.containsKey('def') && map['def'] != null
            ? PlayerInfo.fromMap(map['def'] as Map<String, dynamic>)
            : null,
        reinforcements = (map['reinforcements'] as List<dynamic>)
            .map((e) => DefenseInfo.fromMap(e as Map<String, dynamic>))
            .toList(),
        dateTime = map['dateTime'] as DateTime,
        bounty = (map['bounty'] as List<dynamic>).map((u) => u as int).toList();

  MilitaryReportResponse.fromJson(Map<String, dynamic> map)
      : id = map['_id'] as String,
        failed = map['failed'] as bool,
        mission = Mission.values.byName(map['mission'] as String),
        off = map.containsKey('off') && map['off'] != null
            ? PlayerInfo.fromMap(map['off'] as Map<String, dynamic>)
            : null,
        def = map.containsKey('def') && map['def'] != null
            ? PlayerInfo.fromMap(map['def'] as Map<String, dynamic>)
            : null,
        reinforcements = (map['reinforcements'] as List<dynamic>)
            .map((e) => DefenseInfo.fromMap(e as Map<String, dynamic>))
            .toList(),
        dateTime = DateTime.parse(map['dateTime'] as String),
        bounty = (map['bounty'] as List<dynamic>).map((u) => u as int).toList();

  Map<String, dynamic> toMap() => <String, dynamic>{
        '_id': id,
        'failed': failed,
        'mission': mission.name,
        'off': off?.toMap(),
        'def': off?.toMap(),
        'reinforcements': reinforcements.map((d) => d.toMap()).toList(),
        'dateTime': dateTime,
        'bounty': bounty.map((a) => a).toList(),
      };

  Map<String, dynamic> toJson() => <String, dynamic>{
        '_id': id,
        'failed': failed,
        'mission': mission.name,
        'off': off?.toMap(),
        'def': def?.toMap(),
        'reinforcements': reinforcements.map((d) => d.toMap()).toList(),
        'dateTime': dateTime.toIso8601String(),
        'bounty': bounty.map((a) => a).toList(),
      };

  static List<DefenseInfo> _groupAndReduceDefence(
    List<PlayerInfo> defenceList,
  ) {
    final result = <DefenseInfo>[];
    groupBy(defenceList, (PlayerInfo p) => p.nation).forEach((key, value) {
      final sumUnits = List<int>.filled(10, 0);
      final sumCasualty = List<int>.filled(10, 0);
      for (final playerInfo in value) {
        for (var i = 0; i < playerInfo.units.length; i++) {
          sumUnits[i] = sumUnits[i] + playerInfo.units[i];
          sumCasualty[i] = sumCasualty[i] + playerInfo.casualty[i];
        }
      }
      result.add(
        DefenseInfo(nation: key, units: sumUnits, casualty: sumCasualty),
      );
    });
    return result;
  }

  MilitaryReportResponse copyWith({
    String? id,
    bool? failed,
    Mission? mission,
    PlayerInfo? off,
    PlayerInfo? def,
    List<DefenseInfo>? reinforcements,
    DateTime? dateTime,
    List<int>? bounty,
  }) {
    return MilitaryReportResponse(
      id: id ?? this.id,
      failed: failed ?? this.failed,
      mission: mission ?? this.mission,
      off: off ?? this.off,
      def: def ?? this.def,
      reinforcements: reinforcements ?? this.reinforcements,
      dateTime: dateTime ?? this.dateTime,
      bounty: bounty ?? this.bounty,
    );
  }
}
