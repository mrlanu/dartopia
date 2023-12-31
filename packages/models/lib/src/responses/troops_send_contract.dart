import 'package:equatable/equatable.dart';

class TroopsSendContract extends Equatable {
  final int corX;
  final int corY;
  final List<int> units;
  final String? ownerId;
  final String? settlementId;
  final String? name;
  final DateTime when;

  TroopsSendContract(
      {required this.corX,
      required this.corY,
      required this.units,
      this.ownerId,
      this.settlementId,
      this.name,
      required this.when});

  TroopsSendContract.fromJson(Map<String, dynamic> map)
      : name = map['name'] as String?,
        corX = map['corX'] as int,
        corY = map['corY'] as int,
        units = (map['units'] as List<dynamic>).map((u) => u as int).toList(),
        ownerId = map['ownerId'] as String?,
        settlementId = map['settlementId'] as String?,
        when = DateTime.parse(map['when'] as String);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'corX': corX,
        'corY': corY,
        'units': units,
        'ownerId': ownerId,
        'settlementId': settlementId,
        'when': when.toIso8601String(),
      };

  TroopsSendContract copyWith({
    int? corX,
    int? corY,
    List<int>? units,
    String? ownerId,
    String? settlementId,
    String? name,
    DateTime? when,
  }) {
    return TroopsSendContract(
      corX: corX ?? this.corX,
      corY: corY ?? this.corY,
      units: units ?? this.units,
      ownerId: ownerId ?? this.ownerId,
      settlementId: settlementId ?? this.settlementId,
      name: name ?? this.name,
      when: when ?? this.when,
    );
  }

  @override
  List<Object?> get props => [];
}
