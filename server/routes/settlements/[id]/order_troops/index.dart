import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';

import '../../../../services/settlements_service.dart';

FutureOr<Response> onRequest(
    RequestContext context, String settlementId,) async {
  switch (context.request.method) {
    case HttpMethod.post:
      return _post(context, settlementId);
    case _:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _post(RequestContext context, String settlementId) async {
  final settlementService = context.read<SettlementService>();
  final combatUnitsRequest = OrderCombatUnitRequest.fromMap(
    await context.request.json() as Map<String, dynamic>,
  );
  final result = await settlementService.orderCombatUnits(
    settlementId: settlementId,
    request: combatUnitsRequest,
  );
  return Response.json(
    statusCode:
        result != null ? HttpStatus.created : HttpStatus.internalServerError,
    body: result?.toJson(),
  );
}
