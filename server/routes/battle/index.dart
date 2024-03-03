import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';

import '../../database/database_client.dart';
import '../../services/automation/troops_missions/troop_missions.dart';
import '../../services/settlements_service.dart';
import '../../utils/my_logger.dart';

Future<Response> onRequest(RequestContext context) async {
  final settlementService = context.read<SettlementService>();
  final mongo = DatabaseClient();
  //await mongo.initializeMongo();

  final movements = await settlementService.getMovementsBeforeNow();

  MyLogger.debug('Perform attacks: ${movements.length}');
  for (final m in movements) {
    final strategy = switch (m.mission) {
      Mission.attack || Mission.raid =>
          Attack(
            movement: m,
            mongoService: mongo,
            settlementService: settlementService,
          ),
      Mission.back =>
          BackHome(
            movement: m,
            mongoService: mongo,
            settlementService: settlementService,
          ),
      Mission.reinforcement =>
          Reinforcement(
            movement: m,
            mongoService: mongo,
            settlementService: settlementService,
          ),
      _ => throw ArgumentError('Invalid option'),
    };

    await strategy.handle();

    MyLogger.debug('Attack from ${m.from.villageId} '
        'to ${m.to.villageId} has been performed');
  }

  //await mongo.closeDb();
  return Response(body: 'This is a new route!');
}
