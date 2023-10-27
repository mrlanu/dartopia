import 'package:models/models.dart';

class EmptyTask implements Executable {
  final DateTime when;

  EmptyTask(this.when);

  @override
  void execute(Settlement settlement) {
    // TODO: implement execute
  }

  @override
  DateTime get executionTime => when;
}
