// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

import '../server_date_time.dart';

part 'message_response.freezed.dart';

part 'message_response.g.dart';

@freezed
class MessageResponse with _$MessageResponse {
  const factory MessageResponse({
    required String id,
    required String subject,
    required String body,
    required String senderId,
    required String senderName,
    @JsonKey(fromJson: serverDateTimeFromJson) required DateTime dateTime,
  }) = _MessageResponse;

  factory MessageResponse.fromJson(Map<String, dynamic> json) =>
      _$MessageResponseFromJson(json);
}
