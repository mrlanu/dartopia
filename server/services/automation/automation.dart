import 'package:models/models.dart';

import '../../database/database_client.dart';
import '../../repositories/settlement_repository.dart';
import '../../repositories/statistics_repository.dart';
import '../../utils/my_logger.dart';
import '../settlements_service.dart';
import 'troops_missions/troop_missions.dart';

class Automation {
  Automation({required DatabaseClient databaseClient})
      : _databaseClient = databaseClient,
        _settlementService = SettlementServiceImpl(
            settlementRepository: SettlementRepositoryMongoImpl(
              databaseClient: databaseClient,
            ),
            statisticsRepository:
                StatisticsRepositoryImpl(databaseClient: databaseClient),);
  final SettlementService _settlementService;
  final DatabaseClient _databaseClient;

  Future<void> main() async {
    final movements = await _settlementService.getMovementsBeforeNow();
    print('MOVEMENTS ----------->>>>>>>>>>>> ${movements.length}');

    MyLogger.debug('Perform attacks: ${movements.length}');
    for (final m in movements) {
      final strategy = switch (m.mission) {
        Mission.attack || Mission.raid => Attack(
            movement: m,
            mongoService: _databaseClient,
            settlementService: _settlementService,
          ),
        Mission.back => BackHome(
            movement: m,
            mongoService: _databaseClient,
            settlementService: _settlementService,
          ),
        Mission.reinforcement => Reinforcement(
            movement: m,
            mongoService: _databaseClient,
            settlementService: _settlementService,
          ),
        _ => throw ArgumentError('Invalid option'),
      };

      await strategy.handle();

      MyLogger.debug('Attack from ${m.from.villageId} '
          'to ${m.to.villageId} has been performed');
    }

    await _databaseClient.closeDb();
  }
}
