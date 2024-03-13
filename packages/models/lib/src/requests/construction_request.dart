import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'construction_request.g.dart';

@JsonSerializable()
class ConstructionRequest extends Equatable{
  final int specificationId;
  final int buildingId;
  final int toLevel;

  ConstructionRequest(
      {required this.specificationId,
      required this.buildingId,
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

  @override
  List<Object?> get props => [specificationId, buildingId, toLevel];

}
