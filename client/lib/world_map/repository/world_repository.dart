import 'dart:convert';

import 'package:models/models.dart';
import 'package:http/http.dart' as http;

import '../../consts/api.dart';

abstract class WorldRepository {
  Future<List<MapTile>> fetchPartOfWorld(int fromX, int toX, int fromY, int toY);
  Future<TileDetails> fetchTileDetails(int x, int y);
}

class WorldRepositoryImpl implements WorldRepository {
  @override
  Future<List<MapTile>> fetchPartOfWorld(int fromX, int toX, int fromY, int toY) async {
    final url = Uri.http(baseURL, 'world', {
      'fromX': fromX.toString(),
      'toX': toX.toString(),
      'fromY': fromY.toString(),
      'toY': toY.toString()
    });
    final response = await http.get(url);
    final tilesList = json.decode(response.body) as List<dynamic>;
    final tiles = tilesList
        .map((e) => MapTile.fromJson(e as Map<String, dynamic>))
        .toList();
    return tiles;
  }

  @override
  Future<TileDetails> fetchTileDetails(int x, int y,) async {
    final url = Uri.http(baseURL, 'settlement', {
      'x': x.toString(),
      'y': y.toString(),
    });
    final response = await http.get(url);
    final tileDetailMap = json.decode(response.body) as Map<String, dynamic>;
    return TileDetails.fromJson(tileDetailMap);
  }
}
