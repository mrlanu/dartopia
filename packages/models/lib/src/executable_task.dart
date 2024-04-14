import 'package:models/models.dart';

abstract class Executable {
  //returned int is a statistics points gotten during execution
  int execute(Settlement settlement);
  DateTime get executionTime;
}
