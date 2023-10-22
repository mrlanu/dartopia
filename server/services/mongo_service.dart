import 'package:mongo_dart/mongo_dart.dart';

import '../config/config.dart';

class MongoService {

  Db? _db;

  Future<void> initializeMongo() async {
    if(_db == null){
      _db = await Db.create(Config.mongoDBUrl);
      await _db!.open();
    }
  }

  Future<void> closeDb() async {
    if (_db!.isConnected == true) {
      await _db!.close();
    }
  }

  //collections
  DbCollection get usersCollection => _db!.collection('users');

  DbCollection get booksCollection => _db!.collection('books');
}
