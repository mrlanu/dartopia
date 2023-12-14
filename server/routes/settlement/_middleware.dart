import 'dart:io';
import 'dart:isolate';

import 'package:dart_frog/dart_frog.dart';

import '../../services/automation.dart';
import '../../services/mongo_service.dart';
import '../../utils/my_logger.dart';

const filePath = 'lock.lock';

Handler middleware(Handler handler) {
  return handler.use(
    (handler) {
      return (context) async {
        MyLogger.debug(
            'Got request: ${context.request.method.value} '
                '${context.request.uri.path}',);
        if (context.request.method == HttpMethod.get) {
          await _checkAutomation(context.request.uri.path);
        }
        final response = await handler(context);
        return response;
      };
    },
  );
}

Future<void> _checkAutomation(String initiatorId) async {
  final file = File(filePath);
  if (!file.existsSync()) {
    MyLogger.debug('Automation started by $initiatorId');
    file.createSync();
    await Isolate.run(_performAutomation);
  } else {
    if (file.existsSync() &&
        file
            .statSync()
            .modified
            .isBefore(DateTime.now().subtract(const Duration(seconds: 15)))) {
      file.deleteSync();
    }
  }
}

Future<void> _performAutomation() async {
  final stopwatch = Stopwatch()..start();
  await MongoService.instance.initializeMongo();

  await Automation().main();
  File(filePath).deleteSync();
  stopwatch.stop();
  MyLogger.debug('Automation completed. Elapsed time: '
      '${stopwatch.elapsedMilliseconds} ms');
}
