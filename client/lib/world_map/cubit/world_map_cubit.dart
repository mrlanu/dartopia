import 'package:bloc/bloc.dart';
import 'package:dartopia/consts/consts.dart';
import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

import '../repository/world_repository.dart';

class WorldMapState extends Equatable {
  const WorldMapState({
    this.meta,
    this.loading = true,
    this.error,
    this.villageX = 0,
    this.villageY = 0,
    this.centerX = 0,
    this.centerY = 0,
    this.tilesByCoord = const {},
    this.loadedChunkKeys = const {},
    this.viewSnapSeq = 0,
  });

  final WorldMeta? meta;
  final bool loading;
  final String? error;
  final int villageX;
  final int villageY;
  final int centerX;
  final int centerY;
  final Map<String, MapTile> tilesByCoord;
  final Set<String> loadedChunkKeys;

  /// Bumped when the map should discard pixel drag offset (bootstrap / home).
  final int viewSnapSeq;

  static int _half() => (mapWidth - 1) ~/ 2;

  static int minCenterX(int mapW) {
    final h = _half();
    return (1 + h).clamp(1, mapW);
  }

  static int maxCenterX(int mapW) {
    final h = _half();
    return (mapW - h).clamp(1, mapW);
  }

  static int minCenterY(int mapH) {
    final h = _half();
    return (1 + h).clamp(1, mapH);
  }

  static int maxCenterY(int mapH) {
    final h = _half();
    return (mapH - h).clamp(1, mapH);
  }

  static const Object _unset = Object();

  WorldMapState copyWith({
    WorldMeta? meta,
    bool? loading,
    Object? error = _unset,
    int? villageX,
    int? villageY,
    int? centerX,
    int? centerY,
    Map<String, MapTile>? tilesByCoord,
    Set<String>? loadedChunkKeys,
    int? viewSnapSeq,
  }) {
    return WorldMapState(
      meta: meta ?? this.meta,
      loading: loading ?? this.loading,
      error: identical(error, _unset) ? this.error : error as String?,
      villageX: villageX ?? this.villageX,
      villageY: villageY ?? this.villageY,
      centerX: centerX ?? this.centerX,
      centerY: centerY ?? this.centerY,
      tilesByCoord: tilesByCoord ?? this.tilesByCoord,
      loadedChunkKeys: loadedChunkKeys ?? this.loadedChunkKeys,
      viewSnapSeq: viewSnapSeq ?? this.viewSnapSeq,
    );
  }

  @override
  List<Object?> get props => [
        meta,
        loading,
        error,
        villageX,
        villageY,
        centerX,
        centerY,
        tilesByCoord,
        loadedChunkKeys,
        viewSnapSeq,
      ];
}

class WorldMapCubit extends Cubit<WorldMapState> {
  WorldMapCubit(this._repo) : super(const WorldMapState());

  final WorldRepository _repo;

  /// Use this when a dialog/overlay context cannot see [RepositoryProvider] (e.g. go_router shells).
  WorldRepository get worldRepository => _repo;

  Future<void> bootstrap(int villageX, int villageY) async {
    emit(state.copyWith(
      loading: true,
      error: null,
      villageX: villageX,
      villageY: villageY,
    ));
    try {
      final meta = await _repo.fetchWorldMeta();
      final nx = villageX.clamp(
        WorldMapState.minCenterX(meta.mapWidth),
        WorldMapState.maxCenterX(meta.mapWidth),
      );
      final ny = villageY.clamp(
        WorldMapState.minCenterY(meta.mapHeight),
        WorldMapState.maxCenterY(meta.mapHeight),
      );
      emit(state.copyWith(
        meta: meta,
        centerX: nx,
        centerY: ny,
        loading: false,
        tilesByCoord: const {},
        loadedChunkKeys: const {},
        viewSnapSeq: state.viewSnapSeq + 1,
      ));
      await loadChunksForViewport();
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> recenterToVillage() async {
    final meta = state.meta;
    if (meta == null) return;
    final nx = state.villageX.clamp(
      WorldMapState.minCenterX(meta.mapWidth),
      WorldMapState.maxCenterX(meta.mapWidth),
    );
    final ny = state.villageY.clamp(
      WorldMapState.minCenterY(meta.mapHeight),
      WorldMapState.maxCenterY(meta.mapHeight),
    );
    emit(state.copyWith(
      centerX: nx,
      centerY: ny,
      viewSnapSeq: state.viewSnapSeq + 1,
    ));
    await loadChunksForViewport();
  }

  /// Maps drag deltas to world steps. Server uses corX 1..W (west→east) and corY 1..H
  /// with larger corY toward the **north** (createWorld iterates y from mapHeight down to 1).
  Future<void> nudgeFromPan(double tx, double ty) async {
    const threshold = 24.0;
    var dx = 0;
    var dy = 0;
    if (tx > threshold) {
      dx = -1;
    } else if (tx < -threshold) {
      dx = 1;
    }
    // Screen Y grows downward; dragging down should reveal northern tiles (higher corY).
    if (ty > threshold) {
      dy = 1;
    } else if (ty < -threshold) {
      dy = -1;
    }
    if (dx == 0 && dy == 0) {
      return;
    }
    await nudgeCenterByDelta(dx, dy);
  }

  Future<void> nudgeCenter(int dx, int dy) =>
      nudgeCenterByDelta(dx, dy);

  /// Applies several tile steps in one emit (used while dragging).
  Future<void> nudgeCenterByDelta(int dx, int dy) async {
    final meta = state.meta;
    if (meta == null || (dx == 0 && dy == 0)) {
      return;
    }
    final nx = (state.centerX + dx).clamp(
      WorldMapState.minCenterX(meta.mapWidth),
      WorldMapState.maxCenterX(meta.mapWidth),
    );
    final ny = (state.centerY + dy).clamp(
      WorldMapState.minCenterY(meta.mapHeight),
      WorldMapState.maxCenterY(meta.mapHeight),
    );
    if (nx == state.centerX && ny == state.centerY) {
      return;
    }
    emit(state.copyWith(centerX: nx, centerY: ny));
    await loadChunksForViewport();
  }

  Future<void> loadChunksForViewport() async {
    final meta = state.meta;
    if (meta == null) {
      return;
    }
    final half = (mapWidth - 1) ~/ 2;
    final pending = <String, ({int cx, int cy})>{};
    for (var wx = state.centerX - half; wx <= state.centerX + half; wx++) {
      for (var wy = state.centerY - half; wy <= state.centerY + half; wy++) {
        if (wx < 1 ||
            wx > meta.mapWidth ||
            wy < 1 ||
            wy > meta.mapHeight) {
          continue;
        }
        final cx = (wx - 1) ~/ meta.chunkSize;
        final cy = (wy - 1) ~/ meta.chunkSize;
        final key = '$cx,$cy';
        if (state.loadedChunkKeys.contains(key)) {
          continue;
        }
        pending[key] = (cx: cx, cy: cy);
      }
    }
    if (pending.isEmpty) {
      return;
    }
    final chunks = await Future.wait(
      pending.values.map((c) => _repo.fetchWorldChunk(c.cx, c.cy)),
    );
    final tiles = Map<String, MapTile>.from(state.tilesByCoord);
    final keys = Set<String>.from(state.loadedChunkKeys);
    for (final chunk in chunks) {
      keys.add('${chunk.cx},${chunk.cy}');
      for (final t in chunk.tiles) {
        tiles['${t.corX},${t.corY}'] = t;
      }
    }
    emit(state.copyWith(tilesByCoord: tiles, loadedChunkKeys: keys));
  }
}
