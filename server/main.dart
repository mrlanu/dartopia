import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'database/database_client.dart';
import 'exceptions/exceptions.dart';
import 'server_settings.dart';

final DatabaseClient _databaseClient = DatabaseClient();

Future<void> init(InternetAddress ip, int port) async {
  await _databaseClient.connect();
  await _initServerSettings();
}

///Execute any custom code prior to starting the server
Future<HttpServer> run(Handler handler, InternetAddress ip, int port) async {

  return serve(handler.use(databaseProvider()).use(requestLogger()), ip, port);
}

Middleware databaseProvider() {
  return provider<DatabaseClient>((_) => _databaseClient);
}

Future<void> _initServerSettings() async {
  final serverName = Platform.environment['SERVER_NAME'];
  assert(serverName != null,
      'Server name required ==> SERVER_NAME=... dart_frog dev');
  try {
    if (_databaseClient.db != null && _databaseClient.db!.isConnected) {
      final settings = await _databaseClient.db!
          .collection('settings')
          .findOne(where.eq('serverName', serverName));
      if (settings == null) {
        await _databaseClient.db!
            .collection('settings')
            .insertOne(ServerSettings().toMap(serverName: serverName!));
      } else {
        ServerSettings.initializeFromMap(settings);
      }
    }else{
      throw DatabaseConnectionException();
    }
  }catch(e){rethrow;}
}
