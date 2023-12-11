class ShortSettlementInfo {
  ShortSettlementInfo(
      {required this.isCapital,
      required this.settlementId,
      required this.name,
      required this.x,
      required this.y});

  final bool isCapital;
  final String settlementId;
  final String name;
  final int x;
  final int y;

  ShortSettlementInfo.fromJson(Map<String, dynamic> map)
      : isCapital = map['isCapital'] as bool,
        settlementId = map['settlementId'] as String,
        name = map['name'] as String,
        x = map['x'] as int,
        y = map['y'] as int;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'isCapital': isCapital,
        'settlementId': settlementId,
        'name': name,
        'x': x,
        'y': y,
      };

  ShortSettlementInfo copyWith({
    bool? isCapital,
    String? settlementId,
    String? name,
    int? x,
    int? y,
  }) {
    return ShortSettlementInfo(
        isCapital: isCapital ?? this.isCapital,
        settlementId: settlementId ?? this.settlementId,
        name: name ?? this.name,
        x: x ?? this.x,
        y: y ?? this.y,);
  }
}
