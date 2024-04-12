import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';

import '../../services/statistics_service.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  final request = context.request;
  final params = request.uri.queryParameters;
  final page = params['page'];
  final sortBy = params['sort']!;
  switch (context.request.method) {
    case HttpMethod.get:
      return _get(page, sortBy, context);
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.put:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.post:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(
    String? page, String sortBy, RequestContext context,) async {
  final statisticsService = context.read<StatisticsService>();
  final user = context.read<User>();
  final statisticsList = await statisticsService.getStatisticsList(
    playerId: user.id!,
    page: page,
    sortBy: sortBy,
  );
  return Response.json(body: statisticsList);
}
