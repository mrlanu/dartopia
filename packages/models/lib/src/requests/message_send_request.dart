import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_send_request.freezed.dart';

part 'message_send_request.g.dart';

@freezed
class MessageSendRequest with _$MessageSendRequest {
  const factory MessageSendRequest({
    required String recipientName,
    required String subject,
    required String body,
  }) = _MessageSendRequest;

  factory MessageSendRequest.fromJson(Map<String, dynamic> json) =>
      _$MessageSendRequestFromJson(json);
}
