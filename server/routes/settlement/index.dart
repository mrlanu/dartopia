import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../services/settlements_service.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _get(context);
    case HttpMethod.post:
      return _post(context);
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(RequestContext context) async {
  final settlementService = context.read<SettlementService>();
  final request = context.request;
  final params = request.uri.queryParameters;
  final x = params['x'] ?? '0';
  final y = params['y'] ?? '0';
  final tileDetails = await settlementService.getTileDetailsByCoordinates(
      x: int.parse(x), y: int.parse(y),);
  return Response.json(body: tileDetails);
}

Future<Response> _post(RequestContext context) async {
  final settlementService = context.read<SettlementService>();
  final requestBody = await context.request.json() as Map<String, dynamic>;
  final result = await settlementService.foundNewSettlement(
    userId: requestBody['userId']! as String,
  );

  return Response.json(
    statusCode:
        result != null ? HttpStatus.created : HttpStatus.internalServerError,
    body: result,
  );
}
