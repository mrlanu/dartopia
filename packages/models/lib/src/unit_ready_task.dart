import 'package:models/models.dart';

class UnitReadyTask implements Executable {
  final int unitId;
  final DateTime when;

  UnitReadyTask(this.unitId, this.when);

  @override
  int execute(Settlement settlement) {
    print('Inside UnitReadyTask task execute method.');
    final updatedList = List<int>.from(settlement.units);
    updatedList[unitId] += 1;
    settlement.units = updatedList;
    return 0;
  }

  @override
  DateTime get executionTime => when;
}
