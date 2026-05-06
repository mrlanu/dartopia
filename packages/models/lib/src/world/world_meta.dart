import 'package:equatable/equatable.dart';

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
