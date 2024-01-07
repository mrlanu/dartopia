import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';

import '../../../../services/settlements_service.dart';
import '../../../../services/utils_service.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  switch (context.request.method) {
    case HttpMethod.post:
      return _post(id, context);
    case HttpMethod.get:
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _post(String fromSettlementId, RequestContext context) async {
  final settlementService = context.read<SettlementService>();
  final contract = TroopsSendContract.fromJson(
    await context.request.json() as Map<String, dynamic>,
  );

  final offSettlement = await settlementService.fetchSettlementById(
    settlementId: fromSettlementId,
  );
  final targetSettlement = await settlementService.fetchSettlementByCoordinates(
    x: contract.corX,
    y: contract.corY,
  );

  final when = UtilsService.getArrivalTime(
    toX: contract.corX,
    toY: contract.corY,
    fromX: offSettlement!.x,
    fromY: offSettlement.y,
    units: contract.units,
  );

  return Response.json(
    body: contract.copyWith(
        ownerId: targetSettlement!.userId,
        settlementId: targetSettlement.id.$oid,
        name: targetSettlement.name,
        when: when,),
  );
}
