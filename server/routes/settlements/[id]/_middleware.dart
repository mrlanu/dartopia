import 'dart:convert';
import 'dart:isolate';

import 'package:dart_frog/dart_frog.dart';

import '../../../services/automation/automation.dart';
import '../../../services/mongo_service.dart';
import '../../../utils/my_logger.dart';

bool _lockAcquired = false;

Handler middleware(Handler handler) {
  return (context) async {
    MyLogger.debug(
      'Got request: ${context.request.method.value} '
          '${context.request.uri.path}',
    );
    if (context.request.method == HttpMethod.get) {
      await _checkAutomation(context.request.uri.path);
    }
    final response = await handler(context);
    return response;
  };
}

Future<Response> _checkAutomation(String initiatorId) async {
  if (!_lockAcquired) {
    _lockAcquired = true;
    try {
      await Isolate.run(() => _performAutomation(initiatorId));
    } on StateError catch (e, s) {
      print(e.message); // In a bad state!
      print(LineSplitter.split("$s").first); // Contains "eventualError"
    } finally {
      _lockAcquired = false;
    }
  }
  return Response();
}

Future<void> _performAutomation(String initiatorId) async {
  MyLogger.debug('Automation started by $initiatorId');
  final stopwatch = Stopwatch()..start();
  await MongoService.instance.initializeMongo();

  await Automation().main();
  stopwatch.stop();
  MyLogger.debug('Automation completed. Elapsed time: '
      '${stopwatch.elapsedMilliseconds} ms');
}
