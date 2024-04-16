import 'package:models/models.dart';

class ReportEntity {
  final String? id;
  final List<ReportOwner> reportOwners;
  final Mission mission;
  final List<PlayerInfo> participants; // [off, def, ...reinforcements]
  final DateTime dateTime;
  final List<int> bounty;

  ReportEntity({
    this.id,
    this.reportOwners = const [],
    required this.mission,
    required this.participants,
    required this.dateTime,
    this.bounty = const [0, 0, 0, 0],
  });

  ReportEntity.fromMap(Map<String, dynamic> map)
      : id = map['_id'] as String?,
        reportOwners = (map['reportOwners'] as List<dynamic>)
            .map((r) => ReportOwner.fromJson(r as Map<String, dynamic>))
            .toList(),
        mission = Mission.values.byName(map['mission'] as String),
        participants = (map['participants'] as List<dynamic>)
            .map((e) => PlayerInfo.fromMap(e as Map<String, dynamic>))
            .toList(),
        dateTime = map['dateTime'] as DateTime,
        bounty = (map['bounty'] as List<dynamic>).map((u) => u as int).toList();

  ReportEntity.fromJson(Map<String, dynamic> map)
      : id = map['_id'] as String?,
        reportOwners = (map['reportOwners'] as List<dynamic>)
            .map((r) => ReportOwner.fromJson(r as Map<String, dynamic>))
            .toList(),
        mission = Mission.values.byName(map['mission'] as String),
        participants = (map['participants'] as List<dynamic>)
            .map((e) => PlayerInfo.fromMap(e as Map<String, dynamic>))
            .toList(),
        dateTime = DateTime.parse(map['dateTime'] as String),
        bounty = (map['bounty'] as List<dynamic>).map((u) => u as int).toList();

  Map<String, dynamic> toMap() => <String, dynamic>{
        '_id': id,
        'reportOwners': reportOwners.map((e) => e.toJson()).toList(),
        'mission': mission.name,
        'participants': participants.map((d) => d.toMap()).toList(),
        'dateTime': dateTime,
        'bounty': bounty.map((a) => a).toList(),
      };

  Map<String, dynamic> toJson() => <String, dynamic>{
        '_id': id,
        'reportOwners': reportOwners.map((e) => e.toJson()).toList(),
        'mission': mission.name,
        'participants': participants.map((d) => d.toMap()).toList(),
        'dateTime': dateTime.toIso8601String(),
        'bounty': bounty.map((a) => a).toList(),
      };

  ReportEntity copyWith({
    String? id,
    bool? failed,
    List<ReportOwner>? reportOwners,
    Mission? mission,
    List<PlayerInfo>? participants,
    DateTime? dateTime,
    List<int>? bounty,
  }) {
    return ReportEntity(
      id: id ?? this.id,
      reportOwners: reportOwners ?? this.reportOwners,
      mission: mission ?? this.mission,
      participants: participants ?? this.participants,
      dateTime: dateTime ?? this.dateTime,
      bounty: bounty ?? this.bounty,
    );
  }
}
