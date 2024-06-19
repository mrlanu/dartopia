// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StatisticsResponseImpl _$$StatisticsResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$StatisticsResponseImpl(
      modelsList: (json['modelsList'] as List<dynamic>)
          .map((e) => StatisticsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentPage: json['currentPage'] as int,
      totalItems: json['totalItems'] as int,
      totalPages: json['totalPages'] as int,
      itemsPerPage: json['itemsPerPage'] as int,
    );

Map<String, dynamic> _$$StatisticsResponseImplToJson(
        _$StatisticsResponseImpl instance) =>
    <String, dynamic>{
      'modelsList': instance.modelsList,
      'currentPage': instance.currentPage,
      'totalItems': instance.totalItems,
      'totalPages': instance.totalPages,
      'itemsPerPage': instance.itemsPerPage,
    };
