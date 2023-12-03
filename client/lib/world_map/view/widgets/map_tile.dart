import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:models/models.dart';

class MapTileWidget extends StatelessWidget {
  final MapTile tile;
  final ui.Image image;

  const MapTileWidget({super.key, required this.tile, required this.image});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: CustomPaint(
        painter: TilePainter(image: image, tileNumber: tile.tileNumber),
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
    final Rect destRect =
    Rect.fromPoints(const Offset(0.0, 0.0), Offset(size.width, size.height));

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
