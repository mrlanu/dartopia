import 'dart:convert';

import 'package:models/models.dart';
import 'package:http/http.dart' as http;
import 'package:network/network.dart';

abstract class WorldRepository {
  Future<List<MapTile>> fetchPartOfWorld(
      int fromX, int toX, int fromY, int toY);

  Future<TileDetails> fetchTileDetails(int x, int y);
}

class WorldRepositoryImpl implements WorldRepository {
  WorldRepositoryImpl({NetworkClient? networkClient})
      : _networkClient = networkClient ?? NetworkClient.instance;

  final NetworkClient _networkClient;

  @override
  Future<List<MapTile>> fetchPartOfWorld(
      int fromX, int toX, int fromY, int toY) async {
    final queryParameters = {
      'fromX': fromX.toString(),
      'toX': toX.toString(),
      'fromY': fromY.toString(),
      'toY': toY.toString()
    };
    try {
      final response = await _networkClient.get<List<dynamic>>(
          Api.fetchPartOfWorld(),
          queryParameters: queryParameters);
      final tiles = response.data!
          .map((e) => MapTile.fromJson(e as Map<String, dynamic>))
          .toList();
      return tiles;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  @override
  Future<TileDetails> fetchTileDetails(
    int x,
    int y,
  ) async {
    final queryParameters = {
      'x': x.toString(),
      'y': y.toString(),
    };
    try {
      final response = await _networkClient.get<Map<String, dynamic>>(
          Api.fetchTileDetails(),
          queryParameters: queryParameters);
      return TileDetails.fromJson(response.data!);
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }
}
