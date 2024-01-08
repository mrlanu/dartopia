import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';

import '../../services/reports_service.dart';
import '../../services/settlements_service.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  final user = context.read<User>();
  switch (context.request.method) {
    case HttpMethod.get:
      return _get(context, user.id!);
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.put:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.post:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(RequestContext context, String userId) async {
  final reportsService = context.read<ReportsService>();
  final settlementService = context.read<SettlementService>();
  final reports = await reportsService.createReportsBrief(
      userId: userId, settlementService: settlementService,);
  return Response.json(body: {'amount': reports.$1, 'briefs': reports.$2,});
}
