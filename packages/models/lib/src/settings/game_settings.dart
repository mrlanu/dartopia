import 'package:equatable/equatable.dart';

/// Response body of `GET /settings` (game configuration from the Java server).
class GameSettings extends Equatable {
  const GameSettings({
    required this.serverName,
    required this.mapWidth,
    required this.mapHeight,
    required this.chunkSize,
    required this.oasesAmount,
    required this.troopsSpeedX,
    required this.buildingsSpeedX,
    required this.productionMultiplier,
    required this.minUnitsForOasis,
    required this.maxUnitsForOasis,
    required this.troopBuildDuration,
    required this.maxConstructionTasksInQueue,
    required this.oasisName,
    required this.natureRegTime,
    this.id,
  });

  factory GameSettings.fromJson(Map<String, dynamic> json) {
    return GameSettings(
      serverName: json['serverName'] as String,
      mapWidth: _asInt(json['mapWidth']),
      mapHeight: _asInt(json['mapHeight']),
      chunkSize: _asInt(json['chunkSize']),
      oasesAmount: _asInt(json['oasesAmount']),
      troopsSpeedX: _asInt(json['troopsSpeedX']),
      buildingsSpeedX: _asInt(json['buildingsSpeedX']),
      productionMultiplier: _productionMultiplierFromJson(
          json['productionMultiplier'],),
      minUnitsForOasis: _asInt(json['minUnitsForOasis']),
      maxUnitsForOasis: _asInt(json['maxUnitsForOasis']),
      troopBuildDuration: _asInt(json['troopBuildDuration']),
      maxConstructionTasksInQueue:
          _asInt(json['maxConstructionTasksInQueue']),
      oasisName: json['oasisName'] as String,
      natureRegTime: _asInt(json['natureRegTime']),
      id: json['id'] as String?,
    );
  }

  final String serverName;
  final int mapWidth;
  final int mapHeight;
  final int chunkSize;
  final int oasesAmount;
  final int troopsSpeedX;
  final int buildingsSpeedX;
  final double productionMultiplier;
  final int minUnitsForOasis;
  final int maxUnitsForOasis;
  final int troopBuildDuration;
  final int maxConstructionTasksInQueue;
  final String oasisName;
  final int natureRegTime;
  final String? id;

  static int _asInt(dynamic value) => (value as num).toInt();

  static double _productionMultiplierFromJson(dynamic value) {
    if (value == null) {
      return 1;
    }
    return (value as num).toDouble();
  }

  @override
  List<Object?> get props => [
        serverName,
        mapWidth,
        mapHeight,
        chunkSize,
        oasesAmount,
        troopsSpeedX,
        buildingsSpeedX,
        productionMultiplier,
        minUnitsForOasis,
        maxUnitsForOasis,
        troopBuildDuration,
        maxConstructionTasksInQueue,
        oasisName,
        natureRegTime,
        id,
      ];
}
