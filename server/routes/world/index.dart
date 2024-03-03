import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../server_settings.dart';
import '../../services/world_service.dart';

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
  final worldService = context.read<WorldService>();
  final request = context.request;
  final params = request.uri.queryParameters;
  final fromX = params['fromX'] ?? '0';
  final toX = params['toX'] ?? '0';
  final fromY = params['fromY'] ?? '0';
  final toY = params['toY'] ?? '0';
  final result = await worldService.getPartOfWorldBetweenCoordinates(
    int.parse(fromX),
    int.parse(toX),
    int.parse(fromY),
    int.parse(toY),
  );
  return Response.json(body: result);
}

Future<Response> _post(RequestContext context) async {
  final worldService = context.read<WorldService>();
  final body = await context.request.body();

  //if body is empty default settings will be used from ServerSettings
  //in other case settings will be extracted from request
  if(body.isNotEmpty){
    final settingsRequest =
    await context.request.json() as Map<String, dynamic>;
    ServerSettings.initializeFromMap(settingsRequest);
  }
  await worldService.createWorld();

  return Response.json(
    statusCode: HttpStatus.created,
  );
}
