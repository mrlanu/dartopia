// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_send_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageSendRequestImpl _$$MessageSendRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$MessageSendRequestImpl(
      recipientName: json['recipientName'] as String,
      subject: json['subject'] as String,
      body: json['body'] as String,
    );

Map<String, dynamic> _$$MessageSendRequestImplToJson(
        _$MessageSendRequestImpl instance) =>
    <String, dynamic>{
      'recipientName': instance.recipientName,
      'subject': instance.subject,
      'body': instance.body,
    };
