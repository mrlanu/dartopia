import 'package:models/models.dart';

abstract class Executable {
  void execute(Settlement settlement);
  DateTime get executionTime;
}
