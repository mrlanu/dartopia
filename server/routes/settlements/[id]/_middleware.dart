import 'dart:convert';
import 'dart:isolate';

import 'package:dart_frog/dart_frog.dart';

import '../../../database/database_client.dart';
import '../../../main.dart';
import '../../../server_settings.dart';
import '../../../services/automation/automation.dart';
import '../../../utils/my_logger.dart';

bool _lockAcquired = false;

Handler middleware(Handler handler) {
  return (context) async {
    MyLogger.debug(
      'Got request: ${context.request.method.value} '
      '${context.request.uri.path}',
    );
    if (context.request.method == HttpMethod.get) {
      await _checkAutomation(context.request.uri.path, initialSettingsMap);
    }
    final response = await handler(context);
    return response;
  };
}

Future<Response> _checkAutomation(
    String initiatorId, Map<String, dynamic> serverSettings,) async {
  if (!_lockAcquired) {
    _lockAcquired = true;
    try {
      await Isolate.run(() => _performAutomation(initiatorId, serverSettings));
    } on StateError catch (e, s) {
      MyLogger.warning(e.message); // In a bad state!
      MyLogger.warning(
          LineSplitter.split("$s").first); // Contains "eventualError"
    } finally {
      _lockAcquired = false;
    }
  }
  return Response();
}

Future<void> _performAutomation(
    String initiatorId, Map<String, dynamic> serverSettings,) async {
  MyLogger.debug('Automation started by $initiatorId');
  ServerSettings.initializeFromMap(serverSettings);
  final stopwatch = Stopwatch()..start();
  final databaseClient = DatabaseClient();
  await databaseClient.connect();

  await Automation(databaseClient: databaseClient).main();
  stopwatch.stop();
  MyLogger.debug('Automation completed. Elapsed time: '
      '${stopwatch.elapsedMilliseconds} ms');
}
