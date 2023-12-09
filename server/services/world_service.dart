import 'dart:math';

import 'package:models/models.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../config/config.dart';
import '../repositories/world_repository.dart';

abstract class WorldService {
  Future<void> createWorld();

  Future<List<MapTile>> getPartOfWorldBetweenCoordinates(
    int fromX,
    int toX,
    int fromY,
    int toY,
  );
}

class WorldServiceImpl implements WorldService {
  WorldServiceImpl({required WorldRepository worldRepository})
      : _worldRepository = worldRepository;
  final WorldRepository _worldRepository;
  List<MapTile> tiles = <MapTile>[];

  @override
  Future<void> createWorld() async {
    await _dropWorld();
    _createBlueprint(Config.worldWidth, Config.worldHeight);
    _insertOases(Config.oasesAmount);
    _insertSomeVillages(); //just for development purpose, should be removed later
    await _worldRepository.saveWorld(tiles);
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

  Future<bool> _dropWorld() => _worldRepository.dropWorld();

  void _createBlueprint(int xLength, int yLength) {
    for (var y = yLength; y > 0; y--) {
      for (var x = 1; x < xLength + 1; x++) {
        tiles.add(
          MapTile(
            id: ObjectId(),
            corX: x,
            corY: y,
            name: 'Grass land',
            tileNumber: 0,
          ),
        );
      }
    }
  }

  void _insertOases(int amount) {
    for (var i = 0; i < amount; i++) {
      final emptySpots = tiles.where((tile) => tile.empty).toList();
      final randomNumber = _getRandomNumber(0, emptySpots.length - 1);
      final emptySpot = emptySpots[randomNumber];
      final index = tiles.indexOf(emptySpot);
      tiles
        ..removeAt(index)
        ..insert(
          index,
          emptySpot.copyWith(
            ownerId: 'Nature',
            empty: false,
            name: 'Oasis',
            tileNumber: _getRandomOasis(),
          ),
        );
    }
  }

  int _getRandomOasis() {
    final oases = [3, 5, 7, 17, 19, 27, 29, 41, 43];
    final random = Random();
    return oases[random.nextInt(oases.length)];
  }

  int _getRandomNumber(int min, int max) {
    final random = Random();
    return min + random.nextInt((max - min) + 1);
  }

  void _insertSomeVillages() {
    final myTile =
        tiles.firstWhere((tile) => tile.corX == 25 && tile.corY == 25);
    final index = tiles.indexOf(myTile);
    tiles
      ..removeAt(index)
      ..insert(
          index,
          myTile.copyWith(
              ownerId: '654eaeb5693f198560bc1e5a',
              name: 'New village',
              empty: false,
              tileNumber: 56,),);
    final myTile2 =
    tiles.firstWhere((tile) => tile.corX == 27 && tile.corY == 27);
    final index2 = tiles.indexOf(myTile2);
    tiles
      ..removeAt(index2)
      ..insert(
        index2,
        myTile2.copyWith(
          ownerId: '654eaeb5693f198560bc1e5b',
          name: 'Test',
          empty: false,
          tileNumber: 56,),);
  }
}
