import 'package:models/models.dart';

class PlayerInfo {

  PlayerInfo({
    required this.settlementId,
    required this.settlementName,
    required this.playerName,
    required this.nation,
    required this.units,
    required this.casualty,
    this.bounty = const [0,0,0,0],
    required this.carry,
  });

  PlayerInfo.fromMap(Map<String, dynamic> map)
      : settlementId = map['settlementId'] as String,
        settlementName = map['settlementName'] as String,
        playerName = map['playerName'] as String,
        nation = Nations.values.byName(map['nation'] as String),
        units = (map['units'] as List<dynamic>).map((u) => u as int).toList(),
        casualty = (map['casualty'] as List<dynamic>).map((u) => u as int).toList(),
        bounty = (map['bounty'] as List<dynamic>).map((u) => u as int).toList(),
        carry = map['carry'] as int;
  final String settlementId;
  final String settlementName;
  final String playerName;
  final Nations nation;
  final List<int> units;
  final List<int> casualty;
  final List<int> bounty;
  final int carry;


  Map<String, dynamic> toMap() => <String, dynamic>{
    'settlementId': settlementId,
    'settlementName': settlementName,
    'playerName': playerName,
    'nation': nation.name,
    'units': units.map((a) => a).toList(),
    'casualty': casualty.map((a) => a).toList(),
    'bounty': bounty.map((a) => a).toList(),
    'carry': carry,
  };

  PlayerInfo copyWith({
    String? settlementId,
    String? settlementName,
    String? playerName,
    Nations? nation,
    List<int>? units,
    List<int>? casualty,
    List<int>? bounty,
    int? carry,
  }) {
    return PlayerInfo(
      settlementId: settlementId ?? this.settlementId,
      settlementName: settlementName ?? this.settlementName,
      playerName: playerName ?? this.playerName,
      nation: nation ?? this.nation,
      units: units ?? this.units,
      casualty: casualty ?? this.casualty,
      bounty: bounty ?? this.bounty,
      carry: carry ?? this.carry,
    );
  }
}
