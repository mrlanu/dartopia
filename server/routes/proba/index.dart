import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../../database/database_client.dart';

Future<Response> onRequest(RequestContext context) async {
  final dataClient = context.read<DatabaseClient>();
  final proba =
      Proba.fromJson(await context.request.json() as Map<String, dynamic>);
  if (proba.id != null) {
    final resp = await dataClient.db!.collection('proba').replaceOne(
          where.id(ObjectId.parse(proba.id!)),
          proba.toJson(),
        );
    return Response.json(body: resp.document);
  }else{
    final resp = await dataClient.db!.collection('proba').insertOne(proba.toJson());
    return Response.json(body: resp.document);
  }
}
