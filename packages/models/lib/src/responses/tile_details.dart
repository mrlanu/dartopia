class TileDetails {
  final String id;
  final String playerName;
  final String name;
  final int x;
  final int y;
  final int population;
  final List<int>? animals;
  final double distance;

  TileDetails({
    required this.id,
    required this.playerName,
    required this.name,
    required this.x,
    required this.y,
    required this.population,
    this.animals,
    required this.distance,
  });

  TileDetails.fromJson(Map<String, dynamic> map)
      : id = map['id'] as String,
        playerName = map['playerName'] as String,
        name = map['name'] as String,
        x = map['x'] as int,
        y = map['y'] as int,
        population = map['population'] as int,
        animals = map['animals'] != null
            ? (map['animals'] as List<dynamic>).map((e) => e as int).toList()
            : null,
        distance = map['distance'] as double;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'playerName': playerName,
        'name': name,
        'x': x,
        'y': y,
        'population': population,
        'animals': animals?.map((a) => a).toList(),
        'distance': distance,
      };

  TileDetails copyWith({
    String? id,
    String? playerName,
    String? name,
    int? x,
    int? y,
    int? population,
    List<int>? animals,
    double? distance,
  }) {
    return TileDetails(
      id: id ?? this.id,
      playerName: playerName ?? this.playerName,
      name: name ?? this.name,
      x: x ?? this.x,
      y: y ?? this.y,
      population: population ?? this.population,
      animals: animals ?? this.animals,
      distance: distance ?? this.distance,
    );
  }
}
