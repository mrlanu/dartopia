// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messages_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessagesResponseImpl _$$MessagesResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$MessagesResponseImpl(
      messagesList: (json['messagesList'] as List<dynamic>)
          .map((e) => MessagesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentPage: json['currentPage'] as int,
      totalItems: json['totalItems'] as int,
      totalPages: json['totalPages'] as int,
      itemsPerPage: json['itemsPerPage'] as int,
    );

Map<String, dynamic> _$$MessagesResponseImplToJson(
        _$MessagesResponseImpl instance) =>
    <String, dynamic>{
      'messagesList': instance.messagesList,
      'currentPage': instance.currentPage,
      'totalItems': instance.totalItems,
      'totalPages': instance.totalPages,
      'itemsPerPage': instance.itemsPerPage,
    };
