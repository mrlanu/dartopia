import 'package:models/models.dart';

class UnitReadyTask implements Executable {
  final int unitId;
  final DateTime when;

  UnitReadyTask(this.unitId, this.when);

  @override
  void execute(Settlement settlement) {
    print('Inside UnitReadyTask task execute method.');
    final updatedList = List<int>.from(settlement.units);
    updatedList[unitId] += 1;
    settlement.units = updatedList;
  }

  @override
  DateTime get executionTime => when;
}
