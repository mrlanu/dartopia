import 'package:models/models.dart';

class SendUnitsRequest {
  final String to;
  final List<int> units;
  final Mission mission;

  SendUnitsRequest(
      {required this.to, required this.units, required this.mission});

  SendUnitsRequest.fromMap(Map<String, dynamic> map)
      : to = map['to'] as String,
        units = (map['units'] as List<dynamic>).map((u) => u as int).toList(),
        mission = Mission.values.byName(map['mission'] as String);

  Map<String, dynamic> toMap() => <String, dynamic>{
        'to': to,
        'units': units,
        'mission': mission.name,
      };
}
