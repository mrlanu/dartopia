// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messages_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessagesModelImpl _$$MessagesModelImplFromJson(Map<String, dynamic> json) =>
    _$MessagesModelImpl(
      id: json['id'] as String,
      subject: json['subject'] as String,
      senderName: json['senderName'] as String,
      senderId: json['senderId'] as String,
      recipientName: json['recipientName'] as String,
      recipientId: json['recipientId'] as String,
      read: json['read'] as bool,
      time: DateTime.parse(json['time'] as String),
    );

Map<String, dynamic> _$$MessagesModelImplToJson(_$MessagesModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'subject': instance.subject,
      'senderName': instance.senderName,
      'senderId': instance.senderId,
      'recipientName': instance.recipientName,
      'recipientId': instance.recipientId,
      'read': instance.read,
      'time': instance.time.toIso8601String(),
    };
