class SideBrief {
  final String villageId;
  final String villageName;
  final String playerName;
  final List<int> coordinates;

  SideBrief(
      {required this.villageId,
      required this.villageName,
      required this.playerName,
      required this.coordinates});

  SideBrief.fromJson(Map<String, dynamic> map)
      : villageId = map['villageId'] as String,
        villageName = map['villageName'] as String,
        playerName = map['playerName'] as String,
        coordinates =
            (map['coordinates'] as List<dynamic>).map((u) => u as int).toList();

  Map<String, dynamic> toJson() => <String, dynamic>{
    'villageId': villageId,
    'villageName': villageName,
    'playerName': playerName,
    'coordinates': coordinates,
  };

  SideBrief.fromMap(Map<String, dynamic> map)
      : villageId = map['villageId'] as String,
        villageName = map['villageName'] as String,
        playerName = map['playerName'] as String,
        coordinates =
        (map['coordinates'] as List<dynamic>).map((u) => u as int).toList();

  Map<String, dynamic> toMap() => <String, dynamic>{
    'villageId': villageId,
    'villageName': villageName,
    'playerName': playerName,
    'coordinates': coordinates,
  };
}
