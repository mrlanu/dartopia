import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../../services/reports_service.dart';

FutureOr<Response> onRequest(RequestContext context, String id) async {
  final request = context.request;
  final params = request.uri.queryParameters;
  final userId = params['userId'] ?? '0';
  switch (context.request.method) {
    case HttpMethod.get:
      return _get(context, id, userId);
    case HttpMethod.delete:
      return _delete(context, id, userId);
    case HttpMethod.head:
    case HttpMethod.put:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.post:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(
    RequestContext context, String reportId, String userId,) async {
  final reportsService = context.read<ReportsService>();
  final report =
      await reportsService.fetchReportById(reportId: reportId, userId: userId);
  return Response.json(body: report);
}

Future<Response> _delete(RequestContext context, String id, String userId) async {
  final reportsService = context.read<ReportsService>();
  reportsService.deleteById(id, userId);
  return Response(statusCode: HttpStatus.noContent);
}
