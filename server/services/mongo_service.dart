import 'package:mongo_dart/mongo_dart.dart';
import '../config/config.dart';

class MongoService {

  MongoService._();

  static MongoService? _instance;
  late Db _db;

  static MongoService get instance {
    if (_instance == null) {
      _instance = MongoService._();
      _instance!.initializeMongo();
    }
    return _instance!;
  }

  void initializeMongo() {
    _db = Db(Config.mongoDBUrl);
    _db.open().then((_) {
      print('MongoDB connection opened.');
    });
  }

  Db get db => _db;

  Future<void> closeDb() async {
    if (_db.isConnected == true) {
      await _db.close();
      print('MongoDB connection closed.');
    }
  }

  /*// Collections
  DbCollection get usersCollection => _db.collection('users');
  DbCollection get settlementsCollection => _db.collection('settlements');
  DbCollection get booksCollection => _db.collection('books');*/
}
