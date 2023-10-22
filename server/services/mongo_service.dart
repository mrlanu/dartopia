import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../config/config.dart';

class MongoService {
  static final _db =  Db(Config.mongoDBUrl);

  static Future<void> startDb() async {
    if (_db.isConnected == false) {
      await _db.open();
    }
  }

  static Future<void> closeDb() async {
    if (_db.isConnected == true) {
      await _db.close();
    }
  }

  //collections
  static final usersCollection = _db.collection('users');
  static final booksCollection = _db.collection('books');

  static Future<Response> startConnection(
      RequestContext context,
      Future<Response> callBack,
      ) async {
    try {
      await startDb();
      return await callBack;
    } catch (e) {
      return Response.json(
        statusCode: 500,
        body: {'message': 'Internal server error'},
      );
    }
  }
}
