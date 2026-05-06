import 'package:equatable/equatable.dart';
import 'package:models/src/responses/map_tile.dart';

class WorldChunk extends Equatable {
  const WorldChunk({
    required this.cx,
    required this.cy,
    required this.fromX,
    required this.toX,
    required this.fromY,
    required this.toY,
    required this.tiles,
  });

  final int cx;
  final int cy;
  final int fromX;
  final int toX;
  final int fromY;
  final int toY;
  final List<MapTile> tiles;

  factory WorldChunk.fromJson(Map<String, dynamic> json) {
    return WorldChunk(
      cx: json['cx'] as int,
      cy: json['cy'] as int,
      fromX: json['fromX'] as int,
      toX: json['toX'] as int,
      fromY: json['fromY'] as int,
      toY: json['toY'] as int,
      tiles: (json['tiles'] as List<dynamic>)
          .map((e) => MapTile.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [cx, cy, fromX, toX, fromY, toY, tiles];
}
