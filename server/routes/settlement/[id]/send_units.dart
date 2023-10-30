import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../../../services/settlements_service.dart';

FutureOr<Response> onRequest(RequestContext context, String id) async {
  /*final settlementService = context.read<SettlementService>();
  final settlement = await settlementService.recalculateState(settlementId: id);

  if (settlement == null) {
    return Response(
      statusCode: HttpStatus.notFound,
      body: 'Settlement with id: $id Not found',
    );
  }*/

  switch (context.request.method) {
    case HttpMethod.post:
      return _post(context, id);
    case HttpMethod.delete:
    case HttpMethod.get:
    case HttpMethod.put:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _post(RequestContext context, String settlementId) async {
  final settlementService = context.read<SettlementService>();
  final request = SendUnitsRequest.fromMap(
    await context.request.json() as Map<String, dynamic>,
  );
  final result = await settlementService.sendUnits(fromId: settlementId, request: request);
  return Response.json(
    statusCode:
    result ? HttpStatus.created : HttpStatus.internalServerError,
    body: 'Units has been sent.',
  );
}
