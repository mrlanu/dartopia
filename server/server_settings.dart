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
    required this.chunkSize,
    required this.oasesAmount,
    required this.troopsSpeedX,
    required this.buildingsSpeedX,
    // after development should be deleted(should be gotten from models/UnitsConst)
    required this.troopBuildDuration,
    required this.maxConstructionTasksInQueue,
    required this.oasisName,
    required this.natureRegTime,
  });

  final String serverName;
  final int mapWidth;
  final int mapHeight;
  final int chunkSize;
  final int oasesAmount;
  final int troopsSpeedX;
  final int buildingsSpeedX;

  // after development should be deleted(should be gotten from models/UnitsConst)
  final int troopBuildDuration;
  final int maxConstructionTasksInQueue;
  final String oasisName;
  final int natureRegTime;

  // Singleton instance
  static ServerSettings _instance = ServerSettings._(
      serverName: 'testServer',
      mapWidth: 50,
      mapHeight: 50,
      chunkSize: 16,
      oasesAmount: 100,
      troopsSpeedX: 1,
      buildingsSpeedX: 10,
      troopBuildDuration: 180,
      maxConstructionTasksInQueue: 2,
      oasisName: 'Unoccupied Oasis',
      natureRegTime: 4,
  );

  // Method to initialize settings from JSON
  static void initializeFromMap(Map<String, dynamic> map) {
    _instance = _instance.copyWith(
      serverName: map['serverName'] as String,
      mapWidth: map['mapWidth'] as int,
      mapHeight: map['mapHeight'] as int,
      chunkSize: map['chunkSize'] as int,
      oasesAmount: map['oasesAmount'] as int,
      troopsSpeedX: map['troopsSpeedX'] as int,
      buildingsSpeedX: map['buildingsSpeedX'] as int,
      troopBuildDuration: map['troopBuildDuration'] as int,
      maxConstructionTasksInQueue: map['maxConstructionTasksInQueue'] as int,
      oasisName: map['oasisName'] as String,
      natureRegTime: map['natureRegTime'] as int,
    );
  }

  Map<String, dynamic> toMap({required String serverName}) => <String, dynamic>{
        'serverName': serverName,
        'mapWidth': mapWidth,
        'mapHeight': mapHeight,
        'chunkSize': chunkSize,
        'oasesAmount': oasesAmount,
        'troopsSpeedX': troopsSpeedX,
        'buildingsSpeedX': buildingsSpeedX,
        'troopBuildDuration': troopBuildDuration,
        'maxConstructionTasksInQueue': maxConstructionTasksInQueue,
        'oasisName': oasisName,
        'natureRegTime': natureRegTime,
      };

  ServerSettings copyWith({
    String? serverName,
    int? mapWidth,
    int? mapHeight,
    int? chunkSize,
    int? oasesAmount,
    int? troopsSpeedX,
    int? buildingsSpeedX,
    int? troopBuildDuration,
    int? maxConstructionTasksInQueue,
    String? oasisName,
    int? natureRegTime,
  }) {
    return ServerSettings._(
        serverName: serverName ?? this.serverName,
        mapWidth: mapWidth ?? this.mapWidth,
        mapHeight: mapHeight ?? this.mapHeight,
        chunkSize: chunkSize ?? this.chunkSize,
        oasesAmount: oasesAmount ?? this.oasesAmount,
        troopsSpeedX: troopsSpeedX ?? this.troopsSpeedX,
        buildingsSpeedX: buildingsSpeedX ?? this.buildingsSpeedX,
        troopBuildDuration: troopBuildDuration ?? this.troopBuildDuration,
        maxConstructionTasksInQueue:
            maxConstructionTasksInQueue ?? this.maxConstructionTasksInQueue,
        oasisName: oasisName ?? this.oasisName,
        natureRegTime: natureRegTime ?? this.natureRegTime,
    );
  }
}
