import 'package:freezed_annotation/freezed_annotation.dart';

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
    required DateTime time,}) = _MessagesModel;

  factory MessagesModel.fromJson(Map<String, dynamic> json) =>
      _$MessagesModelFromJson(json);
}
