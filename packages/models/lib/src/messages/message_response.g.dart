// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageResponseImpl _$$MessageResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$MessageResponseImpl(
      id: json['id'] as String,
      subject: json['subject'] as String,
      body: json['body'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
    );

Map<String, dynamic> _$$MessageResponseImplToJson(
        _$MessageResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'subject': instance.subject,
      'body': instance.body,
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'dateTime': instance.dateTime.toIso8601String(),
    };
