// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'construction_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConstructionRequest _$ConstructionRequestFromJson(Map<String, dynamic> json) =>
    ConstructionRequest(
      specificationId: json['buildingId'] as int,
      buildingId: json['position'] as int,
      toLevel: json['toLevel'] as int,
    );

Map<String, dynamic> _$ConstructionRequestToJson(
        ConstructionRequest instance) =>
    <String, dynamic>{
      'buildingId': instance.specificationId,
      'position': instance.buildingId,
      'toLevel': instance.toLevel,
    };
