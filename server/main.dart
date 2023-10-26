import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import 'services/mongo_service.dart';

Future<void> init(InternetAddress ip, int port) async {
  await MongoService.instance.initializeMongo();
}

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) {
  // 1. Execute any custom code prior to starting the server...

  // 2. Use the provided `handler`, `ip`, and `port` to create a custom `HttpServer`.
  // Or use the Dart Frog serve method to do that for you.
  return serve(handler, ip, port);
}
