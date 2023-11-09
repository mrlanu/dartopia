import 'package:freezed_annotation/freezed_annotation.dart';

part 'construction_request.g.dart';

@JsonSerializable()
class ConstructionRequest {
  final int buildingId;
  final int position;
  final int toLevel;

  ConstructionRequest(
      {required this.buildingId,
      required this.position,
      required this.toLevel});

  /*ConstructionRequest.fromMap(Map<String, dynamic> map)
      : buildingId = map['buildingId'] as int,
        position = map['position'] as int,
        toLevel = map['toLevel'] as int;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'buildingId': buildingId.toString(),
        'position': position.toString(),
        'toLevel': toLevel.toString(),
      };*/

  factory ConstructionRequest.fromJson(Map<String, dynamic> json) =>
      _$ConstructionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ConstructionRequestToJson(this);

}
