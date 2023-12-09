class TileDetails {
  String id;
  String playerName;
  String name;
  int x;
  int y;
  int population;
  double distance; // Assuming Dart's double for equivalent to Java's BigDecimal

  TileDetails({
    required this.id,
    required this.playerName,
    required this.name,
    required this.x,
    required this.y,
    required this.population,
    required this.distance,
  });

  TileDetails.fromJson(Map<String, dynamic> map)
      : id = map['id'] as String,
        playerName = map['playerName'] as String,
        name = map['name'] as String,
        x = map['x'] as int,
        y = map['y'] as int,
        population = map['population'] as int,
        distance = map['distance'] as double;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'playerName': playerName,
        'name': name,
        'x': x,
        'y': y,
        'population': population,
        'distance': distance,
      };

  TileDetails copyWith({
    String? id,
    String? playerName,
    String? name,
    int? x,
    int? y,
    int? population,
    double? distance,
  }) {
    return TileDetails(
      id: id ?? this.id,
      playerName: playerName ?? this.playerName,
      name: name ?? this.name,
      x: x ?? this.x,
      y: y ?? this.y,
      population: population ?? this.population,
      distance: distance ?? this.distance,
    );
  }
}
