import 'troop_missions.dart';

class Raid extends MissionStrategy {
  Raid(
      {required super.movement,
      required super.mongoService,
      required super.settlementService});

  @override
  Future<void> handle() async {}
}
