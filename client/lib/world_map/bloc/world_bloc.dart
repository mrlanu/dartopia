import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartopia/consts/consts.dart';
import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

import '../repository/world_repository.dart';

part 'world_event.dart';

part 'world_state.dart';

class WorldBloc extends Bloc<WorldEvent, WorldState> {
  WorldBloc({required this.worldRepository}) : super(const WorldState()) {
    on<WorldFetchRequested>(_onWorldFetchRequested);
    on<CenterRequested>(
      _centerRequested,
    );
    on<XIncremented>(
      _xIncremented,
    );
    on<YIncremented>(
      _yIncremented,
    );
    on<XDecremented>(
      _xDecremented,
    );
    on<YDecremented>(
      _yDecremented,
    );
  }

  final WorldRepository worldRepository;

  Future<void> _centerRequested(
    CenterRequested event,
    Emitter<WorldState> emit,
  ) async {
    final tiles = await _fetchTiles(state.initX, state.initY);
    emit(
      state.copyWith(
        currentX: state.initX,
        currentY: state.initY,
        tiles: tiles,
      ),
    );
  }

  Future<void> _xIncremented(
    XIncremented event,
    Emitter<WorldState> emit,
  ) async {
    if (state.currentX + 1 > worldWidth - mapWidth ~/ 2) {
      return;
    }
    final tiles = await _fetchTiles(state.currentX + 1, state.currentY);
    emit(
      state.copyWith(
        status: WorldStatus.success,
        currentX: state.currentX + 1,
        tiles: tiles,
      ),
    );
  }

  Future<void> _yIncremented(
    YIncremented event,
    Emitter<WorldState> emit,
  ) async {
    if (state.currentY + 1 > worldWidth - mapWidth ~/ 2) {
      return;
    }
    final tiles = await _fetchTiles(state.currentX, state.currentY + 1);
    emit(
      state.copyWith(
        status: WorldStatus.success,
        currentY: state.currentY + 1,
        tiles: tiles,
      ),
    );
  }

  Future<void> _xDecremented(
    XDecremented event,
    Emitter<WorldState> emit,
  ) async {
    if (state.currentX - 1 < (mapWidth + 1) ~/ 2) {
      return;
    }
    final tiles = await _fetchTiles(state.currentX - 1, state.currentY);
    emit(
      state.copyWith(
        status: WorldStatus.success,
        currentX: state.currentX - 1,
        tiles: tiles,
      ),
    );
  }

  Future<void> _yDecremented(
    YDecremented event,
    Emitter<WorldState> emit,
  ) async {
    if (state.currentY - 1 < (mapWidth + 1) ~/ 2) {
      return;
    }
    final tiles = await _fetchTiles(state.currentX, state.currentY - 1);
    emit(
      state.copyWith(
        status: WorldStatus.success,
        currentY: state.currentY - 1,
        tiles: tiles,
      ),
    );
  }

  Future<void> _onWorldFetchRequested(
    WorldFetchRequested event,
    Emitter<WorldState> emit,
  ) async {
    final tiles = await _fetchTiles(event.x, event.y);
    emit(
      state.copyWith(
        status: WorldStatus.success,
        initX: event.x,
        initY: event.y,
        currentX: event.x,
        currentY: event.y,
        tiles: tiles,
      ),
    );
  }

  Future<List<MapTile>> _fetchTiles(int x, int y) async {
    final (fromX, toX, fromY, toY) = _getCoordinatesForRequest(x, y);
    return worldRepository.fetchPartOfWorld(fromX, toX, fromY, toY);
  }

  (int, int, int, int) _getCoordinatesForRequest(int x, int y) {
    const offset = (mapWidth + 1) ~/ 2;
    var fromX = x - offset;
    var toX = x + offset;
    var fromY = y - offset;
    var toY = y + offset;
    if (x - offset < 0) {
      fromX = 0;
      toX = mapWidth + 1;
    }
    if (x + offset > worldWidth) {
      fromX = worldWidth - mapWidth;
      toX = worldWidth + 1;
    }
    if (y - offset < 0) {
      fromY = 0;
      toY = mapWidth + 1;
    }
    if (y + offset > 50) {
      fromY = worldWidth - mapWidth;
      toY = worldWidth + 1;
    }
    return (fromX, toX, fromY, toY);
  }
}
