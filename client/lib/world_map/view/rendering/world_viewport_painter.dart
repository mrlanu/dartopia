import 'dart:ui' as ui;

import 'package:dartopia/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class WorldViewportPainter extends CustomPainter {
  WorldViewportPainter({
    required this.image,
    required this.tilesByCoord,
    required this.centerX,
    required this.centerY,
    required this.tilePixelSize,
  });

  final ui.Image image;
  final Map<String, MapTile> tilesByCoord;
  final int centerX;
  final int centerY;
  final double tilePixelSize;

  @override
  void paint(Canvas canvas, Size size) {
    final half = (mapWidth - 1) ~/ 2;
    for (var r = 0; r < mapWidth; r++) {
      for (var c = 0; c < mapWidth; c++) {
        final wx = centerX - half + c;
        final wy = centerY + half - r;
        final tile = tilesByCoord['$wx,$wy'];
        final dest = Rect.fromLTWH(
          c * tilePixelSize,
          r * tilePixelSize,
          tilePixelSize,
          tilePixelSize,
        );
        if (tile != null) {
          final src = _atlasSrcRect(tile.tileNumber);
          canvas.drawImageRect(image, src, dest, Paint());
        } else {
          canvas.drawRect(
            dest,
            Paint()..color = const Color.fromRGBO(200, 200, 200, 1),
          );
        }
      }
    }
  }

  Rect _atlasSrcRect(int tileNumber) {
    const tileSize = 60;
    const imageWidth = 540;
    final row = tileNumber ~/ (imageWidth ~/ tileSize);
    final col = tileNumber % (imageWidth ~/ tileSize);
    final topLeft = Offset(
      col * tileSize.toDouble(),
      row * tileSize.toDouble(),
    );
    final bottomRight = Offset(
      (col + 1) * tileSize.toDouble(),
      (row + 1) * tileSize.toDouble(),
    );
    return Rect.fromPoints(topLeft, bottomRight);
  }

  @override
  bool shouldRepaint(covariant WorldViewportPainter oldDelegate) {
    return oldDelegate.image != image ||
        oldDelegate.tilesByCoord != tilesByCoord ||
        oldDelegate.centerX != centerX ||
        oldDelegate.centerY != centerY ||
        oldDelegate.tilePixelSize != tilePixelSize;
  }
}
