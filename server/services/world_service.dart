import 'dart:math';

import 'package:models/models.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../repositories/world_repository.dart';
import '../server_settings.dart';

abstract class WorldService {
  Future<void> createWorld();

  Future<List<MapTile>> getPartOfWorldBetweenCoordinates(
    int fromX,
    int toX,
    int fromY,
    int toY,
  );

  Future<void> insertSettlement({
    required String settlementId,
    required int x,
    required int y,
  });
}

class WorldServiceImpl implements WorldService {
  WorldServiceImpl({required WorldRepository worldRepository})
      : _worldRepository = worldRepository;
  final WorldRepository _worldRepository;
  List<MapTile> tiles = <MapTile>[];

  @override
  Future<void> createWorld() async {
    await _dropWorld();
    final random = Random();
    // Probabilities must sum to 1
    final tileProbability = [
      (0, 0.78), (3, 0.02), (5, 0.02), (7, 0.02), (17, 0.02), //
      (19, 0.02), (27, 0.02), (29, 0.02), (31, 0.02), //
      (41, 0.02), (43, 0.02), (45, 0.02), //
    ];

    final cumulativeProbabilities = <double>[];
    var cumulativeSum = 0.0;
    for (final tileProbability in tileProbability) {
      cumulativeSum += tileProbability.$2;
      cumulativeProbabilities.add(cumulativeSum);
    }

    for (var y = ServerSettings().mapHeight; y > 0; y--) {
      for (var x = 1; x < ServerSettings().mapWidth + 1; x++) {
        final randomValue = random.nextDouble();
        for (var i = 0; i < cumulativeProbabilities.length; i++) {
          if (randomValue < cumulativeProbabilities[i]) {
            tiles.add(
              MapTile(
                id: ObjectId(),
                corX: x,
                corY: y,
                name: tileProbability[i].$1 == 0 ? 'Grass land' : 'Oases',
                tileNumber: tileProbability[i].$1,
              ),
            );
            break;
          }
        }
      }
    }

    _printResult(tileProbability);

    await _worldRepository.saveWorld(tiles);
  }

  void _printResult(List<(int, double)> tileProbability) {
    for (final tileProb in tileProbability) {
      final count = tiles.where((t) => t.tileNumber == tileProb.$1)
          .fold(0, (previousValue, element) => previousValue + 1);
      print('Inserted ${tileProb.$1} - $count',);
    }
  }

  @override
  Future<List<MapTile>> getPartOfWorldBetweenCoordinates(
    int fromX,
    int toX,
    int fromY,
    int toY,
  ) async {
    return _worldRepository.getPartOfWorldBetweenCoordinates(
      fromX,
      toX,
      fromY,
      toY,
    );
  }

  @override
  Future<void> insertSettlement({
    required String settlementId,
    required int x,
    required int y,
  }) async {
    final myTile = await _worldRepository.getMapTileByCoordinates(x, y);
    final updatedTile = myTile.copyWith(
      ownerId: settlementId,
      name: 'New village',
      empty: false,
      tileNumber: 56,
    );
    await _worldRepository.updateMapTile(updatedTile);
  }

  Future<bool> _dropWorld() => _worldRepository.dropWorld();
}
