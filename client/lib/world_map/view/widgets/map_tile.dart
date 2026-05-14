import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import '../../repository/world_repository.dart';


/// Uses [repo] directly so the tile dialog works when [showDialog]'s route is outside [RepositoryProvider]'s scope (go_router shell / root navigator).
Future<void> showMapTileDetailsDialog(
    BuildContext navigatorContext,
    WorldRepository repo,
    MapTile tile,
    List<int> myCoordinates,
    ) {
  return showDialog<void>(
    context: navigatorContext,
    builder: (_) {
      final height = MediaQuery.of(navigatorContext).size.height * 0.5;
      return Center(
        child: Dialog(
          insetPadding: const EdgeInsets.all(10),
          child: SizedBox(
            height: height,
            child: Center(
              child: FutureBuilder<TileDetails>(
                future: repo.fetchTileDetails(myCoordinates[0], myCoordinates[1], tile.corX, tile.corY),
                builder: (_, snapshot) {
                  return snapshot.connectionState == ConnectionState.done
                      ? MapTileDialogBody(tileDetails: snapshot.data!)
                      : SizedBox(
                    height: height,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
    },
  );
}

class MapTileDialogBody extends StatelessWidget {
  const MapTileDialogBody({super.key, required this.tileDetails});

  final TileDetails tileDetails;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
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
                'Distance: ${tileDetails.distance.toStringAsFixed(1)}',
                style: textTheme.titleMedium,
              ),
              tileDetails.animals != null
                  ? _MapTileDialogAnimals(
                      tileDetails: tileDetails,
                      maxWidth: constraints.maxWidth,
                    )
                  : const SizedBox(),
              IconButton.outlined(
                  iconSize: 30,
                  color: Colors.green,
                  onPressed: () {
                    context.push(
                        '/rally_point/1?x=${tileDetails.x}&y=${tileDetails.y}');
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  icon: const FaIcon(FontAwesomeIcons.khanda)),
            ],
          ),
        );
      },
    );
  }
}

class _MapTileDialogAnimals extends StatelessWidget {
  const _MapTileDialogAnimals({
    required this.tileDetails,
    required this.maxWidth,
  });

  final TileDetails tileDetails;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...tileDetails.animals!
            .asMap()
            .entries
            .map((e) => tileDetails.animals?[e.key] == 0
                ? const SizedBox()
                : SizedBox(
                    width: (maxWidth - maxWidth * 0.1) / 6,
                    height: 22,
                    child: Center(
                      child: Row(
                        children: [
                          Container(
                            width: 21.0,
                            height: 21.0,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                alignment: Alignment(-1.0 + 0.217 * e.key, 0.0),
                                image: AssetImage(
                                    DartopiaImages.getTroopsByNation(
                                        Nations.nature)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Text(' / ${tileDetails.animals?[e.key]}'),
                        ],
                      ),
                    ),
                  ))
            .toList(),
      ],
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
