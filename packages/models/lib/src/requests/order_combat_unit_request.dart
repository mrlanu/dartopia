class OrderCombatUnitRequest {
  final int unitId;
  final int amount;

  OrderCombatUnitRequest(
      {required this.unitId, required this.amount});

  OrderCombatUnitRequest.fromMap(Map<String, dynamic> map)
      : unitId = map['unitId'] as int,
        amount = map['amount'] as int;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'unitId': unitId,
        'amount': amount,
      };
}
