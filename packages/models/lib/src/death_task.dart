import 'package:models/models.dart';

class DeathTask implements Executable{


  DeathTask(this.when);

  final DateTime when;

  @override
  void execute(Settlement settlement) {
    // TODO: implement execute
  }

  @override
  DateTime get executionTime => when;

}
