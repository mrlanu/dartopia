// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_owner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportOwner _$ReportOwnerFromJson(Map<String, dynamic> json) => ReportOwner(
      playerId: json['playerId'] as String,
      status: json['status'] as int? ?? 0,
    );

Map<String, dynamic> _$ReportOwnerToJson(ReportOwner instance) =>
    <String, dynamic>{
      'playerId': instance.playerId,
      'status': instance.status,
    };
