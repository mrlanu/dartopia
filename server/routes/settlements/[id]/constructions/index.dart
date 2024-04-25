import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';

import '../../../../services/settlements_service.dart';

FutureOr<Response> onRequest(RequestContext context, String settlementId) async {

  switch (context.request.method) {
    case HttpMethod.post:
      return _post(context, settlementId);
    case HttpMethod.delete:
      return _delete(context, settlementId);
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
  final taskRequest = ConstructionRequest.fromJson(
      await context.request.json() as Map<String, dynamic>,);
  final result = await settlementService.addConstructionTask(
    settlementId: settlementId,
    request: taskRequest,
  );
  return Response.json(
    statusCode:
        result != null ? HttpStatus.created : HttpStatus.internalServerError,
    body: result?.toJson(),
  );
}

Future<Response> _delete(RequestContext context, String id) async {
  return Response(statusCode: HttpStatus.noContent);
}
