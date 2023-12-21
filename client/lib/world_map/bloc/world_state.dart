part of 'world_bloc.dart';

enum WorldStatus { initial, success, failure }

final class WorldState extends Equatable {
  const WorldState({
    this.status = WorldStatus.initial,
    this.initX = worldWidth ~/ 2,
    this.initY = worldWidth ~/ 2,
    this.currentX = worldWidth ~/ 2,
    this.currentY = worldWidth ~/ 2,
    this.tiles = const <MapTile>[],
  });

  final WorldStatus status;
  final int initX;
  final int initY;
  final int currentX;
  final int currentY;
  final List<MapTile> tiles;

  WorldState copyWith({
    WorldStatus? status,
    int? initX,
    int? initY,
    int? currentX,
    int? currentY,
    List<MapTile>? tiles,
  }) {
    return WorldState(
      status: status ?? this.status,
      initX: initX ?? this.initX,
      initY: initY ?? this.initY,
      currentX: currentX ?? this.currentX,
      currentY: currentY ?? this.currentY,
      tiles: tiles ?? this.tiles,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, posts: ${tiles.length} }''';
  }

  @override
  List<Object> get props => [status, initX, initY, currentX, currentY, tiles];
}
