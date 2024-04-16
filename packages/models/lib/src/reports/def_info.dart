import '../../models.dart';

class DefenseInfo {
  DefenseInfo({
    required this.nation,
    required this.units,
    required this.casualty,
  });

  final Nations nation;
  final List<int> units;
  final List<int> casualty;

  DefenseInfo.fromMap(Map<String, dynamic> map)
      : nation = Nations.values.byName(map['nation'] as String),
        units = (map['units'] as List<dynamic>).map((u) => u as int).toList(),
        casualty =
            (map['casualty'] as List<dynamic>).map((u) => u as int).toList();

  Map<String, dynamic> toMap() => <String, dynamic>{
        'nation': nation.name,
        'units': units.map((a) => a).toList(),
        'casualty': casualty.map((a) => a).toList(),
      };
}
