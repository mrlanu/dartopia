import 'package:equatable/equatable.dart';
import 'package:models/src/settings/game_settings.dart';

class WorldMeta extends Equatable {
  const WorldMeta({
    required this.mapWidth,
    required this.mapHeight,
    required this.chunkSize,
    required this.chunksX,
    required this.chunksY,
    required this.revision,
  });

  final int mapWidth;
  final int mapHeight;
  final int chunkSize;
  final int chunksX;
  final int chunksY;
  final int revision;

  /// Matches server `WorldServiceImpl#getWorldMeta` (map size and [GameSettings.chunkSize]).
  factory WorldMeta.fromGameSettings(
    GameSettings settings, {
    int revision = 1,
  }) {
    final w = settings.mapWidth;
    final h = settings.mapHeight;
    final cs = settings.chunkSize;
    final cnX = (w + cs - 1) ~/ cs;
    final cnY = (h + cs - 1) ~/ cs;
    return WorldMeta(
      mapWidth: w,
      mapHeight: h,
      chunkSize: cs,
      chunksX: cnX,
      chunksY: cnY,
      revision: revision,
    );
  }

  factory WorldMeta.fromJson(Map<String, dynamic> json) {
    return WorldMeta(
      mapWidth: json['mapWidth'] as int,
      mapHeight: json['mapHeight'] as int,
      chunkSize: json['chunkSize'] as int,
      chunksX: json['chunksX'] as int,
      chunksY: json['chunksY'] as int,
      revision: (json['revision'] as num).toInt(),
    );
  }

  @override
  List<Object?> get props =>
      [mapWidth, mapHeight, chunkSize, chunksX, chunksY, revision];
}
