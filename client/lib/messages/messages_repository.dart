import 'package:models/models.dart';
import 'package:network/network.dart';

abstract class MessagesRepository {
  Future<MessagesResponse> fetchMessages({
    String? page,
    bool sent = false,
  });

  Future<int> countNewMessages();
}

class MessagesRepositoryImpl implements MessagesRepository {
  MessagesRepositoryImpl({NetworkClient? networkClient})
      : _networkClient = networkClient ?? NetworkClient.instance;

  final NetworkClient _networkClient;

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
  Future<int> countNewMessages() async{
    try {
      final response = await _networkClient
          .get<int>(Api.countNewMessages());
      return response.data?? 0;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }
}

