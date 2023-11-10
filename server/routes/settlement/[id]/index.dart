import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';

import '../../../services/settlements_service.dart';



FutureOr<Response> onRequest(RequestContext context, String id) async {
  final settlementService = context.read<SettlementService>();
  final settlement = await settlementService.tryToGetSettlement(settlementId: id);

  if (settlement == null) {
    return Response(
        statusCode: HttpStatus.notFound,
        body: 'Settlement with id: $id Not found',);
  }

  switch (context.request.method) {
    case HttpMethod.get:
      return _get(context, settlement);
    case HttpMethod.put:
      return _put(context, id, settlement);
    case HttpMethod.delete:
      return _delete(context, id);
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.post:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(RequestContext context, Settlement settlement) async {
  print('Response has been sent for ID: ${settlement.id}');
  return Response.json(
      body: settlement.toJson(),);
}

Future<Response> _put(
    RequestContext context, String id, Settlement settlement) async {
  /*final dataSource = context.read<TodosDataSource>();
  final updatedTodo = Todo.fromJson(await context.request.json());
  final newTodo = await dataSource.update(
    id,
    todo.copyWith(
      title: updatedTodo.title,
      description: updatedTodo.description,
      isCompleted: updatedTodo.isCompleted,
    ),
  );*/

  return Response.json(body: settlement);
}

Future<Response> _delete(RequestContext context, String id) async {
  /*final dataSource = context.read<TodosDataSource>();
  await dataSource.delete(id);*/
  return Response(statusCode: HttpStatus.noContent);
}
