import 'package:models/models.dart';

import '../../../database/database_client.dart';
import '../../settlements_service.dart';

abstract class MissionStrategy {
  MissionStrategy({
    required this.movement,
    required this.mongoService,
    required this.settlementService,
  });

  Movement movement;
  final DatabaseClient mongoService;
  final SettlementService settlementService;

  Future<void> handle();
}
