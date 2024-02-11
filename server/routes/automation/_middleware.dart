import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:dart_frog/dart_frog.dart';
import '../../utils/my_logger.dart';

bool _lockAcquired = false;

Handler middleware(Handler handler) {
  return (context) async {
    MyLogger.debug(
      'Got request: ${context.request.method.value} '
          '${context.request.uri.path} Lock: $_lockAcquired',
    );
    if (context.request.method == HttpMethod.get) {
      await handleRequest(context);
    }
    final response = await handler(context);
    return response;
  };
}

Future<Response> handleRequest(RequestContext request) async {
  if (!_lockAcquired) {
    _lockAcquired = true;
    try{
      await Isolate.run(_performHeavyTask);
    }on StateError catch (e, s) {
      print(e.message); // In a bad state!
      print(LineSplitter.split("$s").first); // Contains "eventualError"
    } finally {
      _lockAcquired = false;
    }
  }
  return Response(body: 'Request processed');
}

Future<void> _performHeavyTask() async {
  print('Heavy task started');
  await Future.delayed(const Duration(seconds: 15), () {
    print('Heavy task completed');
  });
}

Future<void> performOtherTask() async {
  print('Performing other task');
  await Future.delayed(Duration(seconds: 1));
  print('Other task completed');
}
