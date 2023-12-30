import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';

import '../../services/automation/troops_missions/attack.dart';
import '../../services/automation/troops_missions/raid.dart';
import '../../services/battle/battle.dart';
import '../../services/battle/main_battle.dart';
import '../../services/mongo_service.dart';
import '../../services/settlements_service.dart';
import '../../utils/my_logger.dart';

Future<Response> onRequest(RequestContext context) async {
  final settlementService = context.read<SettlementService>();
  final mongo = MongoService.instance;
  await mongo.initializeMongo();

  final movements = await settlementService.getMovementsBeforeNow();

  MyLogger.debug('Perform attacks: ${movements.length}');
  for (final m in movements) {
    final strategy = switch (m.mission) {
      Mission.attack => Attack(
        movement: m,
        mongoService: mongo,
        settlementService: settlementService,),
      Mission.raid => Raid(
        movement: m,
        mongoService: mongo,
        settlementService: settlementService,),
      _ => throw ArgumentError('Invalid option'),
    };

    await strategy.handle();

    MyLogger.debug('Attack from ${m.from.villageId} '
        'to ${m.to.villageId} has been performed');
  }

  await mongo.closeDb();

  /*final battle = Battle();
  const battleField = BattleField(tribe: 2, population: 100);
  final off = Army(side: ESide.OFF,
      population: 100,
      units: UnitsConst.UNITS[2],
      numbers: [0, 110, 0, 0, 0, 0, 0, 0, 0, 0],);
  final def = Army(side: ESide.DEF,
      population: 100,
      units: UnitsConst.UNITS[2],
      numbers: [50, 0, 0, 0, 0, 0, 0, 0, 0, 0],);

  battle.perform(battleField, [def, off]);*/
  return Response(body: 'This is a new route!');
}
