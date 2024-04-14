import 'package:models/models.dart';

class DeathTask implements Executable{


  DeathTask(this.when);

  final DateTime when;

  @override
  int execute(Settlement settlement) {
    return 0;
  }

  @override
  DateTime get executionTime => when;

}
