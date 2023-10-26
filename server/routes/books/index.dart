import 'dart:io';
import 'dart:isolate';

import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';

import '../../models/models.dart';

const filePath = 'lock.lock';
final file = File(filePath);

Future<void> performAutomation() async {
  print('Automation has been started');
  await Future.delayed(const Duration(seconds: 5));
  print('Automation has been completed.');
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
  final user = context.read<User>();
  return Response.json(
    body: {
      'status': 200,
      'message': user,
      'data': allBooks,
    },
  );
}
