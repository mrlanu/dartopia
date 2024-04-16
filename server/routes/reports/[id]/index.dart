import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';

import '../../../services/reports_service.dart';

FutureOr<Response> onRequest(RequestContext context, String id) async {
  final user = context.read<User>();
  switch (context.request.method) {
    case HttpMethod.get:
      return _get(context, id, user.id!);
    case HttpMethod.delete:
      return _delete(context, id, user.id!);
    case HttpMethod.head:
    case HttpMethod.put:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.post:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(
  RequestContext context,
  String reportId,
  String userId,
) async {
  final reportsService = context.read<ReportsService>();
  final report = await reportsService.fetchReportById(
      reportId: reportId, playerId: userId,);
  return Response.json(body: report);
}

Future<Response> _delete(
  RequestContext context,
  String id,
  String userId,
) async {
  final reportsService = context.read<ReportsService>();
  await reportsService.deleteById(id, userId);
  return Response(statusCode: HttpStatus.noContent);
}
