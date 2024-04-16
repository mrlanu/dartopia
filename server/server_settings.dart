class ServerSettings {
  // Factory method to get the singleton instance
  factory ServerSettings() {
    return _instance;
  }

  // Private constructor
  ServerSettings._({
    required this.serverName,
    required this.mapWidth,
    required this.mapHeight,
    required this.oasesAmount,
    required this.troopsSpeedX,
    // after development should be deleted(should be gotten from models/UnitsConst)
    required this.troopBuildDuration,
    required this.maxConstructionTasksInQueue,
  });

  final String serverName;
  final int mapWidth;
  final int mapHeight;
  final int oasesAmount;
  final int troopsSpeedX;
  // after development should be deleted(should be gotten from models/UnitsConst)
  final int troopBuildDuration;
  final int maxConstructionTasksInQueue;

  // Singleton instance
  static ServerSettings _instance = ServerSettings._(
    serverName: 'testServer',
    mapWidth: 50,
    mapHeight: 50,
    oasesAmount: 100,
    troopsSpeedX: 1,
    troopBuildDuration: 180,
    maxConstructionTasksInQueue: 2,
  );

  // Method to initialize settings from JSON
  static void initializeFromMap(Map<String, dynamic> map) {
    _instance = _instance.copyWith(
      serverName: map['serverName'] as String,
      mapWidth: map['mapWidth'] as int,
      mapHeight: map['mapHeight'] as int,
      oasesAmount: map['oasesAmount'] as int,
      troopsSpeedX: map['troopsSpeedX'] as int,
      troopBuildDuration: map['troopBuildDuration'] as int,
      maxConstructionTasksInQueue: map['maxConstructionTasksInQueue'] as int,
    );
  }

  Map<String, dynamic> toMap({required String serverName}) => <String, dynamic>{
        'serverName': serverName,
        'mapWidth': mapWidth,
        'mapHeight': mapHeight,
        'oasesAmount': oasesAmount,
        'troopsSpeedX': troopsSpeedX,
        'troopBuildDuration': troopBuildDuration,
        'maxConstructionTasksInQueue': maxConstructionTasksInQueue,
      };

  ServerSettings copyWith({
    String? serverName,
    int? mapWidth,
    int? mapHeight,
    int? oasesAmount,
    int? troopsSpeedX,
    int? troopBuildDuration,
    int? maxConstructionTasksInQueue,
  }) {
    return ServerSettings._(
      serverName: serverName ?? this.serverName,
      mapWidth: mapWidth ?? this.mapWidth,
      mapHeight: mapHeight ?? this.mapHeight,
      oasesAmount: oasesAmount ?? this.oasesAmount,
      troopsSpeedX: troopsSpeedX ?? this.troopsSpeedX,
      troopBuildDuration: troopBuildDuration ?? this.troopBuildDuration,
      maxConstructionTasksInQueue:
          maxConstructionTasksInQueue ?? this.maxConstructionTasksInQueue,
    );
  }
}
