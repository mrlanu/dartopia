import 'dart:math';

import 'package:models/models.dart';

import '../server_settings.dart';

class UtilsService{

  UtilsService._();

  static DateTime getArrivalTime({
    required int toX,
    required int toY,
    required int fromX,
    required int fromY,
    required List<int> units,
  }) {
    final distance = _getDistance(toX, toY, fromX, fromY);
    final speed = _getSlowestSpeed(units) * ServerSettings().troopsSpeedX;
    final hours = distance / speed;
    final seconds = (hours * 3600).round();
    final arrivalDateTime = DateTime.now().add(Duration(seconds: seconds));
    return arrivalDateTime;
  }

  static int _getSlowestSpeed(List<int> units) {
    var speed = 1000;
    for (var i = 0; i < units.length; i++) {
      final unit = UnitsConst.UNITS[2][i];
      if (units[i] > 0 && unit.velocity < speed) {
        speed = unit.velocity;
      }
    }
    return speed;
  }

  static double _getDistance(int toX, int toY, int fromX, int fromY) {
    final legX = pow(toX - fromX, 2);
    final legY = pow(toY - fromY, 2);
    return sqrt(legX + legY);
  }
}
