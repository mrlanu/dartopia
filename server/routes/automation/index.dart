import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';

import '../../services/automation/troops_missions/troop_missions.dart';
import '../../services/mongo_service.dart';
import '../../services/settlements_service.dart';
import '../../utils/my_logger.dart';

Future<Response> onRequest(RequestContext context) async {
  return Response(body: 'Done');
}
