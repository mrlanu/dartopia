import 'dart:async';

import 'package:dartopia/authentication/bloc/auth_bloc.dart';
import 'package:dartopia/consts/consts.dart';
import 'package:dartopia/settlement/bloc/settlement_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:ui' as ui;

import '../../consts/images.dart';
import '../world_map.dart';

class WorldMapPage extends StatelessWidget {
  const WorldMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    //final token = context.read<AuthBloc>().state.token;
    final WorldRepository worldRepo = WorldRepositoryImpl(token: 'token');
    final currentSettlement = context.read<SettlementBloc>().state.settlement!;
    return RepositoryProvider(
      create: (context) => worldRepo,
      child: BlocProvider(
        create: (context) => WorldBloc(worldRepository: worldRepo)
          ..add(WorldFetchRequested(
              x: currentSettlement.x, y: currentSettlement.y)),
        child: const WorldView(),
      ),
    );
  }
}

class WorldView extends StatelessWidget {
  const WorldView({super.key});

  final int itemCount = mapWidth * mapWidth;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _loadImage(),
        builder: (context, snapshot) {
          return BlocBuilder<WorldBloc, WorldState>(
            builder: (context, state) {
              return state.status == WorldStatus.success &&
                      snapshot.connectionState == ConnectionState.done
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildXAxis(context, state.currentX),
                        Row(
                          children: [
                            _buildYAxis(context, state.currentY),
                            Expanded(
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: mapWidth,
                                ),
                                itemCount: itemCount,
                                itemBuilder: (context, index) {
                                  return MapTileWidget(
                                    tile: state.tiles[index],
                                    image: snapshot.data!,
                                  );
                                },
                              ),
                            ),
                            _buildYAxis(context, state.currentY),
                          ],
                        ),
                        _buildXAxis(context, state.currentX),
                        const SizedBox(
                          height: 50,
                        ),
                        const MapButtonRow(),
                      ],
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    );
            },
          );
        });
  }

  Widget _buildXAxis(BuildContext context, int currentX) {
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
                      color: const Color.fromRGBO(164, 206, 128, 1.0)),
                  child: Center(
                      child: Text(
                    '${(index + currentX - (mapWidth - 1) / 2).toInt()}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )),
                ))
      ],
    );
  }

  Widget _buildYAxis(BuildContext context, int currentY) {
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
                      color: const Color.fromRGBO(164, 206, 128, 1.0)),
                  child: Center(
                      child: Text(
                    '${(currentY + (mapWidth - 1) / 2 - index).toInt()}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )),
                ))
      ],
    );
  }

  Future<ui.Image> _loadImage() async {
    final ByteData data = await rootBundle.load(DartopiaImages.tiles);
    final codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetHeight: 660,
      targetWidth: 540,
    );
    var frame = await codec.getNextFrame();
    return frame.image;
  }
}
