import 'package:dartopia/rally_point/rally_point.dart';
import 'package:dartopia/world_map/repository/world_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:ui' as ui;

import 'package:models/models.dart';

import '../../../settlement/settlement.dart';

class MapTileWidget extends StatelessWidget {
  final MapTile tile;
  final ui.Image image;

  const MapTileWidget({super.key, required this.tile, required this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('ONE TAP on: ${tile.id.$oid}');
      },
      onDoubleTap: () {
        tile.tileNumber == 56 ? _openDialog(context) : null;
      },
      child: SizedBox(
        child: CustomPaint(
          painter: TilePainter(image: image, tileNumber: tile.tileNumber),
        ),
      ),
    );
  }

  Future<String?> _openDialog(BuildContext context) {
    return showDialog<String>(
        context: context,
        builder: (_) {
          final height = MediaQuery.of(context).size.height * 0.5;
          return Center(
            child: Dialog(
              insetPadding: const EdgeInsets.all(10),
              child: SizedBox(
                height: height,
                child: Center(
                  child: FutureBuilder(
                    future: context
                        .read<WorldRepository>()
                        .fetchTileDetails(tile.corX, tile.corY),
                    builder: (_, snapshot) {
                      return snapshot.connectionState == ConnectionState.done
                          ? _buildDialogBody(snapshot.data!, context)
                          : SizedBox(
                              height: height,
                              child: const Center(
                                  child: CircularProgressIndicator()));
                    },
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget _buildDialogBody(TileDetails tileDetails, BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            '${tileDetails.name} (${tileDetails.x}|${tileDetails.y})',
            style: textTheme.titleLarge,
          ),
          const Divider(),
          Text('Player name: ${tileDetails.playerName}',
              style: textTheme.titleMedium),
          Text(
            'Population: ${tileDetails.population}',
            style: textTheme.titleMedium,
          ),
          Text(
            'Distance: ${tileDetails.distance}',
            style: textTheme.titleMedium,
          ),
          IconButton.outlined(
              iconSize: 30,
              color: Colors.green,
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(RallyPointPage.route(
                    movementsBloc: context.read<MovementsBloc>(),
                    troopMovementsRepository:
                        context.read<TroopMovementsRepository>(),
                    settlementBloc: context.read<SettlementBloc>(),
                    tabIndex: 1,
                    targetCoordinates: [tileDetails.x, tileDetails.y]));
              },
              icon: const FaIcon(FontAwesomeIcons.khanda)),
        ],
      ),
    );
  }
}

class TilePainter extends CustomPainter {
  final ui.Image image;
  final int tileNumber;

  TilePainter({required this.image, this.tileNumber = 1});

  @override
  void paint(Canvas canvas, Size size) {
    final coordinates = _calculateTileCoordinates(tileNumber, 60, 540);
    // Specify the source Rect to define the portion of the image to draw
    final Rect srcRect = Rect.fromPoints(coordinates.$1, coordinates.$2);

    // Specify the destination Rect to define where to draw the portion on the canvas
    final Rect destRect = Rect.fromPoints(
        const Offset(0.0, 0.0), Offset(size.width, size.height));

    // Draw the portion of the image onto the canvas
    canvas.drawImageRect(image, srcRect, destRect, Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  (Offset, Offset) _calculateTileCoordinates(
      int tileIndex, int tileSize, int imageWidth) {
    // Calculate the row and column of the tile
    int row = tileIndex ~/ (imageWidth ~/ tileSize);
    int column = tileIndex % (imageWidth ~/ tileSize);

    // Calculate top-left and bottom-right coordinates of the tile
    Offset topLeft =
        Offset(column * tileSize.toDouble(), row * tileSize.toDouble());
    Offset bottomRight = Offset(
        (column + 1) * tileSize.toDouble(), (row + 1) * tileSize.toDouble());

    return (topLeft, bottomRight);
  }
}
