import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';

import '../../services/settlements_service.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  final user = context.read<User>();
  switch (context.request.method) {
    case HttpMethod.get:
      return _get(context, user.id!);
    case HttpMethod.post:
      return _post(context, user.id!);
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(RequestContext context, String userId) async {
  final settlementService = context.read<SettlementService>();
  final shortInfos = await settlementService.getSettlementsIdByUserId(
    userId: userId,);
  return Response.json(body: shortInfos);
}

Future<Response> _post(RequestContext context, String userId) async {
  final settlementService = context.read<SettlementService>();
  final requestBody = await context.request.json() as Map<String, dynamic>;
  final result = await settlementService.foundNewSettlement(
    userId: requestBody[userId]! as String,
  );

  return Response.json(
    statusCode:
        result != null ? HttpStatus.created : HttpStatus.internalServerError,
    body: result,
  );
}
