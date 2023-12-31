import 'package:models/models.dart';

import '../../repositories/settlement_repository.dart';
import '../../utils/my_logger.dart';
import '../mongo_service.dart';
import '../settlements_service.dart';
import 'troops_missions/troop_missions.dart';

class Automation {
  Automation({SettlementService? settlementService})
      : _settlementService = settlementService ??
            SettlementServiceImpl(
              settlementRepository: SettlementRepositoryMongoImpl(),
            );
  final SettlementService _settlementService;

  Future<void> main() async {
    final mongo = MongoService.instance;
    final movements = await _settlementService.getMovementsBeforeNow();
    print('MOVEMENTS ----------->>>>>>>>>>>> ${movements.length}');
    //final movements = <Movement>[];

    MyLogger.debug('Perform attacks: ${movements.length}');
    for (final m in movements) {
      final strategy = switch (m.mission) {
        Mission.attack || Mission.raid => Attack(
            movement: m,
            mongoService: mongo,
            settlementService: _settlementService,
          ),
        Mission.back => BackHome(
            movement: m,
            mongoService: mongo,
            settlementService: _settlementService,
          ),
        Mission.reinforcement => Reinforcement(
          movement: m,
          mongoService: mongo,
          settlementService: _settlementService,
        ),
        _ => throw ArgumentError('Invalid option'),
      };

      await strategy.handle();

      MyLogger.debug('Attack from ${m.from.villageId} '
          'to ${m.to.villageId} has been performed');
    }

    await mongo.closeDb();
  }
}
