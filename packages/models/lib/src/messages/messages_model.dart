// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

import '../server_date_time.dart';

part 'messages_model.freezed.dart';
part 'messages_model.g.dart';

@freezed
class MessagesModel with _$MessagesModel {

  const factory MessagesModel({
    required String id,
    required String subject,
    required String senderName,
    required String senderId,
    required String recipientName,
    required String recipientId,
    required bool read,
    @JsonKey(fromJson: serverDateTimeFromJson) required DateTime time,
  }) = _MessagesModel;

  factory MessagesModel.fromJson(Map<String, dynamic> json) =>
      _$MessagesModelFromJson(json);
}
