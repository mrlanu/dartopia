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
    builder: (dialogContext) {
      final maxHeight = MediaQuery.of(dialogContext).size.height * 0.75;
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: FutureBuilder<TileDetails>(
            future: repo.fetchTileDetails(
                myCoordinates[0], myCoordinates[1], tile.corX, tile.corY),
            builder: (_, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              return MapTileDialogBody(tileDetails: snapshot.data!);
            },
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${tileDetails.name} (${tileDetails.x}|${tileDetails.y})',
            style: textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          Text(
            'Player name: ${tileDetails.playerName}',
            style: textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'Population: ${tileDetails.population}',
            style: textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'Distance: ${tileDetails.distance.toStringAsFixed(1)}',
            style: textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          if (tileDetails.animals != null) ...[
            const SizedBox(height: 12),
            _MapTileDialogAnimals(tileDetails: tileDetails),
          ],
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.center,
            child: IconButton.outlined(
              iconSize: 28,
              color: Colors.green,
              onPressed: () {
                context.push(
                    '/rally_point/1?x=${tileDetails.x}&y=${tileDetails.y}');
                Navigator.of(context, rootNavigator: true).pop();
              },
              icon: const FaIcon(FontAwesomeIcons.khanda),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapTileDialogAnimals extends StatelessWidget {
  const _MapTileDialogAnimals({required this.tileDetails});

  final TileDetails tileDetails;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final entry in tileDetails.animals!.asMap().entries)
          if (entry.value != 0)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      alignment: Alignment(-1.0 + 0.217 * entry.key, 0.0),
                      image: AssetImage(
                          DartopiaImages.getTroopsByNation(Nations.nature)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Text(
                  ' / ${entry.value}',
                  style: textTheme.labelSmall,
                ),
              ],
            ),
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
