import 'package:models/models.dart';

import '../../services.dart';
import '../../settlements_service.dart';

abstract class MissionStrategy {
  MissionStrategy({
    required this.movement,
    required this.mongoService,
    required this.settlementService,
  });

  Movement movement;
  final MongoService mongoService;
  final SettlementService settlementService;

  Future<void> handle();
}
