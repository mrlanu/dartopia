// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StatisticsModelImpl _$$StatisticsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$StatisticsModelImpl(
      position: json['position'] as int?,
      playerId: json['playerId'] as String,
      playerName: json['playerName'] as String,
      allianceName: json['allianceName'] as String,
      population: json['population'] as int? ?? 0,
      villagesAmount: json['villagesAmount'] as int? ?? 1,
      attackPoint: json['attackPoint'] as int? ?? 0,
      defensePoint: json['defensePoint'] as int? ?? 0,
    );

Map<String, dynamic> _$$StatisticsModelImplToJson(
        _$StatisticsModelImpl instance) =>
    <String, dynamic>{
      'position': instance.position,
      'playerId': instance.playerId,
      'playerName': instance.playerName,
      'allianceName': instance.allianceName,
      'population': instance.population,
      'villagesAmount': instance.villagesAmount,
      'attackPoint': instance.attackPoint,
      'defensePoint': instance.defensePoint,
    };
