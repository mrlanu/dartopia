import 'dart:async';
import 'dart:ui' as ui;

import 'package:dartopia/consts/consts.dart';
import 'package:dartopia/settlement/bloc/settlement_bloc.dart';
import 'package:dartopia/world_map/cubit/world_map_cubit.dart';
import 'package:dartopia/world_map/repository/world_repository.dart';
import 'package:dartopia/world_map/view/rendering/world_viewport_painter.dart';
import 'package:dartopia/world_map/view/widgets/map_button_row.dart';
import 'package:dartopia/world_map/view/widgets/map_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';

class WorldMapPage extends StatelessWidget {
  const WorldMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final worldRepo = WorldRepositoryImpl();
    final currentSettlement = context.read<SettlementBloc>().state.settlement!;
    return RepositoryProvider(
      create: (context) => worldRepo,
      child: BlocProvider(
        create: (context) => WorldMapCubit(worldRepo)
          ..bootstrap(currentSettlement.x, currentSettlement.y),
        child: const WorldView(),
      ),
    );
  }
}

class WorldView extends StatefulWidget {
  const WorldView({super.key});

  @override
  State<WorldView> createState() => _WorldViewState();
}

class _WorldViewState extends State<WorldView> {
  late final Future<ui.Image> _atlasFuture;

  /// Sub-tile drag offset so the grid follows the finger between whole-tile steps.
  Offset _panRemainder = Offset.zero;

  @override
  void initState() {
    super.initState();
    _atlasFuture = _loadAtlas();
  }

  Future<ui.Image> _loadAtlas() async {
    final data = await rootBundle.load(DartopiaImages.tiles);
    final codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetHeight: 660,
      targetWidth: 540,
    );
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  /// Returns how many whole tiles to commit; reduces [_panRemainder] by tilePx each.
  (int sx, int sy) _extractTileSteps(double tilePx) {
    if (tilePx <= 0) {
      return (0, 0);
    }
    var sx = 0;
    var sy = 0;
    while (_panRemainder.dx >= tilePx) {
      sx -= 1;
      _panRemainder = Offset(_panRemainder.dx - tilePx, _panRemainder.dy);
    }
    while (_panRemainder.dx <= -tilePx) {
      sx += 1;
      _panRemainder = Offset(_panRemainder.dx + tilePx, _panRemainder.dy);
    }
    while (_panRemainder.dy >= tilePx) {
      sy += 1;
      _panRemainder = Offset(_panRemainder.dx, _panRemainder.dy - tilePx);
    }
    while (_panRemainder.dy <= -tilePx) {
      sy -= 1;
      _panRemainder = Offset(_panRemainder.dx, _panRemainder.dy + tilePx);
    }
    return (sx, sy);
  }

  /// Uses [State.context] (not BlocBuilder's callback context) so provider lookup matches the pre-refactor GridView widgets.
  void _onDoubleTapDown(TapDownDetails details, double tilePx) {
    final state = context.read<WorldMapCubit>().state;
    final meta = state.meta;
    if (meta == null) {
      return;
    }
    final half = (mapWidth - 1) ~/ 2;
    final local = details.localPosition;
    final c = (local.dx / tilePx).floor();
    final r = (local.dy / tilePx).floor();
    if (c < 0 || c >= mapWidth || r < 0 || r >= mapWidth) {
      return;
    }
    final wx = state.centerX - half + c;
    final wy = state.centerY + half - r;
    final tile = state.tilesByCoord['$wx,$wy'];
    if (tile == null || tile.tileNumber == 0) {
      return;
    }
    final repo = context.read<WorldMapCubit>().worldRepository;
    unawaited(showMapTileDetailsDialog(context, repo, tile));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final tilePx = width * 0.9 / mapWidth;
    final gridExtent = tilePx * mapWidth;

    return FutureBuilder<ui.Image>(
      future: _atlasFuture,
      builder: (context, snapshot) {
        return BlocBuilder<WorldMapCubit, WorldMapState>(
          builder: (context, state) {
            if (state.error != null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(state.error!, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () => context
                            .read<WorldMapCubit>()
                            .bootstrap(state.villageX, state.villageY),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }
            if (state.loading ||
                state.meta == null ||
                snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            return BlocListener<WorldMapCubit, WorldMapState>(
              listenWhen: (prev, curr) =>
                  prev.viewSnapSeq != curr.viewSnapSeq,
              listener: (context, state) {
                if (mounted) {
                  setState(() => _panRemainder = Offset.zero);
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildXAxis(context, state.centerX, tilePx),
                  Row(
                    children: [
                      _buildYAxis(context, state.centerY, tilePx),
                      Expanded(
                        child: ClipRect(
                          child: SizedBox(
                            height: gridExtent,
                            width: double.infinity,
                            child: Center(
                              child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onPanStart: (_) {
                                setState(() => _panRemainder = Offset.zero);
                              },
                              onPanUpdate: (details) {
                                _panRemainder += details.delta;
                                final steps = _extractTileSteps(tilePx);
                                setState(() {});
                                if (steps.$1 != 0 || steps.$2 != 0) {
                                  unawaited(
                                    context.read<WorldMapCubit>().nudgeCenterByDelta(
                                          steps.$1,
                                          steps.$2,
                                        ),
                                  );
                                }
                              },
                              onPanEnd: (_) {
                                final r = _panRemainder;
                                setState(() => _panRemainder = Offset.zero);
                                unawaited(
                                  context
                                      .read<WorldMapCubit>()
                                      .nudgeFromPan(r.dx, r.dy),
                                );
                              },
                              onDoubleTapDown: (d) =>
                                  _onDoubleTapDown(d, tilePx),
                              child: Transform.translate(
                                offset: _panRemainder,
                                child: CustomPaint(
                                  size: Size(gridExtent, gridExtent),
                                  painter: WorldViewportPainter(
                                    image: snapshot.data!,
                                    tilesByCoord: state.tilesByCoord,
                                    centerX: state.centerX,
                                    centerY: state.centerY,
                                    tilePixelSize: tilePx,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ),
                      ),
                      _buildYAxis(context, state.centerY, tilePx),
                    ],
                  ),
                  _buildXAxis(context, state.centerX, tilePx),
                  const SizedBox(height: 50),
                  const MapButtonRow(),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildXAxis(BuildContext context, int currentX, double tilePx) {
    final width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...List.generate(
          mapWidth,
          (index) => Container(
            width: width * 0.9 / mapWidth,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              color: const Color.fromRGBO(164, 206, 128, 1.0),
            ),
            child: Center(
              child: Text(
                '${(index + currentX - (mapWidth - 1) / 2).toInt()}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildYAxis(BuildContext context, int currentY, double tilePx) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...List.generate(
          mapWidth,
          (index) => Container(
            width: 20,
            height: width * 0.9 / mapWidth,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              color: const Color.fromRGBO(164, 206, 128, 1.0),
            ),
            child: Center(
              child: Text(
                '${(currentY + (mapWidth - 1) / 2 - index).toInt()}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
