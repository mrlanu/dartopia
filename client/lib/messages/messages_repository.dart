import 'dart:convert';

import 'package:models/models.dart';
import 'package:network/network.dart';

abstract class MessagesRepository {

  Future<void> sendMessage(
      {required MessageSendRequest request});

  Future<MessagesResponse> fetchMessages({
    String? page,
    bool sent = false,
  });

  Future<MessageResponse> fetchMessageById({String? messageId,});

  Future<int> countNewMessages();

  Future<void> delete(List<String> checkedMessagesId);
}

class MessagesRepositoryImpl implements MessagesRepository {
  MessagesRepositoryImpl({NetworkClient? networkClient})
      : _networkClient = networkClient ?? NetworkClient.instance;

  final NetworkClient _networkClient;

  @override
  Future<void> sendMessage(
      {required MessageSendRequest request}) async {
    try {
      final response = await _networkClient.post<Map<String, dynamic>>(
          Api.sendMessage(),
          data: request.toJson());
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  @override
  Future<MessagesResponse> fetchMessages(
      {String? page, String? pageSize, bool sent = false}) async {
    try {
      final response = await _networkClient
          .get<Map<String, dynamic>>(Api.fetchMessages(page, pageSize, sent: sent));
      final result = MessagesResponse.fromJson(response.data!);
      return result;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  @override
  Future<MessageResponse> fetchMessageById(
      {String? messageId}) async {
    try {
      final response = await _networkClient
          .get<Map<String, dynamic>>(Api.fetchMessageById(messageId: messageId));
      return MessageResponse.fromJson(response.data!);
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  @override
  Future<int> countNewMessages() async{
    try {
      final response = await _networkClient
          .get<int>(Api.countNewMessages());
      return response.data?? 0;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  @override
  Future<void> delete(List<String> checkedMessagesId) async {
    try {
      await _networkClient
          .post<void>(Api.deleteMessages(), data: json.encode(checkedMessagesId));
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }
}

