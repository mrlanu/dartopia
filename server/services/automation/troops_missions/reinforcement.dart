import 'package:mongo_dart/mongo_dart.dart';

import 'troop_missions.dart';

class Reinforcement extends MissionStrategy {
  Reinforcement({required super.movement,
    required super.mongoService,
    required super.settlementService,});

  @override
  Future<void> handle() async {
    await mongoService.db
        .collection('movements')
        .updateOne(where.id(movement.id!), modify.set('isMoving', false));
  }
}
