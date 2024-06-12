// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'construction_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConstructionRequest _$ConstructionRequestFromJson(Map<String, dynamic> json) =>
    ConstructionRequest(
      specificationId: json['specificationId'] as int,
      buildingId: json['buildingId'] as int,
      toLevel: json['toLevel'] as int,
    );

Map<String, dynamic> _$ConstructionRequestToJson(
        ConstructionRequest instance) =>
    <String, dynamic>{
      'specificationId': instance.specificationId,
      'buildingId': instance.buildingId,
      'toLevel': instance.toLevel,
    };
