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
      currentPage: json['currentPage'] as String,
      totalItems: json['totalItems'] as String,
      totalPages: json['totalPages'] as String,
      itemsPerPage: json['itemsPerPage'] as String,
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
