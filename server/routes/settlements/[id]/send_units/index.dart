import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';

import '../../../../services/settlements_service.dart';

FutureOr<Response> onRequest(RequestContext context, String id) async {
  switch (context.request.method) {
    case HttpMethod.post:
      return _post(context, id);
    case _:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _post(RequestContext context, String settlementId) async {
  final settlementService = context.read<SettlementService>();
  final request = SendTroopsRequest.fromMap(
    await context.request.json() as Map<String, dynamic>,
  );
  final result =
      await settlementService.sendUnits(fromId: settlementId, request: request);
  return Response.json(
    statusCode: result ? HttpStatus.created : HttpStatus.internalServerError,
    body: 'Units has been sent.',
  );
}
