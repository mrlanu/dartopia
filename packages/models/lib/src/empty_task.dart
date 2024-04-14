import 'package:models/models.dart';

class EmptyTask implements Executable {
  final DateTime when;

  EmptyTask(this.when);

  @override
  int execute(Settlement settlement) {
    return 0;
  }

  @override
  DateTime get executionTime => when;
}
