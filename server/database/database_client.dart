import 'package:mongo_dart/mongo_dart.dart';

import '../config/config.dart';
import '../utils/my_logger.dart';

class DatabaseClient {

  factory DatabaseClient(){
    _instance ??= DatabaseClient._();
    return _instance!;
  }
  DatabaseClient._();

  Db? _db;
  static DatabaseClient? _instance;

  Future<void> connect() async {
    if (_db != null) {
      return;
    }
    final db = await Db.create(Config.mongoDBUrl);
    await db.open();
    _db = db;
  }

  Future<void> closeDb() async {
    if (_db != null && _db!.isConnected == true) {
      await _db!.close();
      MyLogger.debug('MongoDB connection closed.');
    }
  }

  Db? get db => _db;
}
