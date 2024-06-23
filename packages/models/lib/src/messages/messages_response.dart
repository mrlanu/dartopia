import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:models/src/messages/messages_model.dart';

part 'messages_response.freezed.dart';

part 'messages_response.g.dart';

@freezed
class MessagesResponse with _$MessagesResponse {
  const factory MessagesResponse({
    required List<MessagesModel> messagesList,
    required int currentPage,
    required int totalItems,
    required int totalPages,
    required int itemsPerPage,
  }) = _MessagesResponse;

  factory MessagesResponse.fromJson(Map<String, dynamic> json) =>
      _$MessagesResponseFromJson(json);
}
