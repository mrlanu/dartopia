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
    required this.productionMultiplier,
    required this.troopsTrainingMultiplier,
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
  final double productionMultiplier;

  final double troopsTrainingMultiplier;
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
      productionMultiplier: 1,
      troopsTrainingMultiplier: 1,
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
      productionMultiplier: _readProductionMultiplier(map),
      troopsTrainingMultiplier: _readTroopsTrainingMultiplier(map),
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
        'productionMultiplier': productionMultiplier,
        'troopsTrainingMultiplier': troopsTrainingMultiplier,
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
    double? productionMultiplier,
    double? troopsTrainingMultiplier,
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
        productionMultiplier:
            productionMultiplier ?? this.productionMultiplier,
        troopsTrainingMultiplier:
            troopsTrainingMultiplier ?? this.troopsTrainingMultiplier,
        maxConstructionTasksInQueue:
            maxConstructionTasksInQueue ?? this.maxConstructionTasksInQueue,
        oasisName: oasisName ?? this.oasisName,
        natureRegTime: natureRegTime ?? this.natureRegTime,
    );
  }
}

double _readTroopsTrainingMultiplier(Map<String, dynamic> map) {
  final v = map['troopsTrainingMultiplier'];
  if (v == null) {
    return 1;
  }
  return (v as num).toDouble();
}

double _readProductionMultiplier(Map<String, dynamic> map) {
  final v = map['productionMultiplier'];
  if (v == null) {
    return 1;
  }
  return (v as num).toDouble();
}
