class NewConstructionRequest {
  final int buildingId;
  final int position;
  final int toLevel;

  NewConstructionRequest(
      {required this.buildingId,
      required this.position,
      required this.toLevel});

  NewConstructionRequest.fromMap(Map<String, dynamic> map)
      : buildingId = map['buildingId'] as int,
        position = map['position'] as int,
        toLevel = map['toLevel'] as int;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'buildingId': buildingId,
        'position': position,
        'toLevel': toLevel,
      };
}
