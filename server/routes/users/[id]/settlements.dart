import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../../services/settlements_service.dart';

FutureOr<Response> onRequest(RequestContext context, String userId) async {

  switch (context.request.method) {
    case HttpMethod.get:
      return _get(context, userId);
    case HttpMethod.post:
    case HttpMethod.delete:
    case HttpMethod.put:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(RequestContext context, String userId) async {
  final settlementService = context.read<SettlementService>();
  final shortInfos = await settlementService.getSettlementsIdByUserId(
    userId: userId,);
  return Response.json(body: shortInfos);
}
