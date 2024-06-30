import 'package:freezed_annotation/freezed_annotation.dart';

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
    required DateTime dateTime,
  }) = _MessageResponse;

  factory MessageResponse.fromJson(Map<String, dynamic> json) =>
      _$MessageResponseFromJson(json);
}
