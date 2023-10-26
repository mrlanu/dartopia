import 'package:models/models.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'mongo_service.dart';

Future<void> automationMain() async {
  final mongo = MongoService.instance;
  final movements = await mongo.db
      .collection('movements')
      .find(where.lte('when', DateTime.now()))
      .map(Movement.fromMap)
      .toList();

  print('Got ${movements.length} movements');
  movements.forEach(print);
  await mongo.closeDb();
}
