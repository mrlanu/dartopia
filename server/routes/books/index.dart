import 'dart:io';
import 'dart:isolate';

import 'package:dart_frog/dart_frog.dart';

import '../../models/models.dart';

const filePath = 'lock.lock';
final file = File(filePath);

Future<void> performAutomation() async {
  //await Future.delayed(const Duration(seconds: 15));
  file.deleteSync();
}

Future<Response> onRequest(RequestContext context) async {
  if (!file.existsSync()) {
    file.createSync();
    Isolate.run(performAutomation);
  } else {
    if (file.existsSync() && file
        .statSync()
        .modified
        .isBefore(DateTime.now().subtract(const Duration(seconds: 5)))) {
      file.deleteSync();
    }
  }
  return switch (context.request.method) {
    HttpMethod.get => _onGet(context),
    _ => Future.value(
        Response(statusCode: HttpStatus.methodNotAllowed),
      ),
  };
}

Future<Response> _onGet(RequestContext context) async {
  final allBooks = books;
  return Response.json(
    body: {
      'status': 200,
      'message': '',
      'data': allBooks,
    },
  );
}
