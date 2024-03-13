import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../../../services/settlements_service.dart';

FutureOr<Response> onRequest(RequestContext context, String id) async {
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
  final buildings = (await context.request.json() as List<dynamic>)
      .map((b) => (b as List<dynamic>).map((e) => e as int).toList())
      .toList();
  await settlementService.reorderBuildings(
    settlementId: settlementId,
    buildings: buildings,
  );
  return Response.json();
}
