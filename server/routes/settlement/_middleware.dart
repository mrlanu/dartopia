import 'dart:io';
import 'dart:isolate';

import 'package:dart_frog/dart_frog.dart';

import '../../repositories/settlement_repository.dart';
import '../../services/automation.dart';
import '../../services/mongo_service.dart';
import '../../services/settlements_service.dart';

const filePath = 'lock.lock';

final _settlementRepository = SettlementRepositoryMongoImpl();
final _settlementService =
    SettlementServiceImpl(settlementRepository: _settlementRepository);

Handler middleware(Handler handler) {
  return handler.use(
    (handler) {
      return (context) async {
        if (context.request.method == HttpMethod.get) {
          await _checkAutomation(context.request.url.toString());
        }
        final response = await handler(context);
        return response;
      };
    },
  ).use(provider<SettlementService>((_) => _settlementService));
}

Future<void> _checkAutomation(String s) async {
  final file = File(filePath);
  if (!file.existsSync()) {
    print('Automation started by ID: ${s}');
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

  //simulate some heavy calculation
  for (var i = 0; i < 5; i++) {
   _computeFactorial(35435);
  }

  await automationMain();

  File(filePath).deleteSync();
  stopwatch.stop();
  print(
      'Automation completed. Elapsed time: ${stopwatch.elapsedMilliseconds} ms');
}

BigInt _computeFactorial(int n) {
  var tempResult = BigInt.one;
  for (var i = n; i > 0; i--) {
    tempResult = tempResult * BigInt.from(i);
  }
  return tempResult;
}
