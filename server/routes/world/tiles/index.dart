import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../../services/settlements_service.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _get(context);
    case HttpMethod.post:
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
