import 'dart:math';

class Common {
  Common._();

  static DateTime getArrivalTime({
    required int x,
    required int y,
    required int fromX,
    required int fromY,
    int speed = 10,
  }) {
    final distance = _getDistance(x, y, fromX, fromY);
    final hours = distance / speed;
    final seconds = (hours * 3600).round();
    final arrivalDateTime = DateTime.now().add(Duration(seconds: seconds));
    return arrivalDateTime;
  }

  static double _getDistance(int x, int y, int fromX, int fromY) {
    final legX = pow(x - fromX, 2);
    final legY = pow(y - fromY, 2);
    return sqrt(legX + legY);
  }
}
