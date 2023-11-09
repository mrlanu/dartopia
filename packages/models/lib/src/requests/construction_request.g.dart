// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'construction_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConstructionRequest _$ConstructionRequestFromJson(Map<String, dynamic> json) =>
    ConstructionRequest(
      buildingId: json['buildingId'] as int,
      position: json['position'] as int,
      toLevel: json['toLevel'] as int,
    );

Map<String, dynamic> _$ConstructionRequestToJson(
        ConstructionRequest instance) =>
    <String, dynamic>{
      'buildingId': instance.buildingId,
      'position': instance.position,
      'toLevel': instance.toLevel,
    };
