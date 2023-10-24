import 'package:models/models.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../services/mongo_service.dart';

abstract class UserRepository {
  Future<User?> findByEmail({required String email});
  Future<WriteResult> insertOne({required User user});
}

class UserRepositoryMongo extends UserRepository {
  UserRepositoryMongo({required MongoService mongoService})
      : _mongoService = mongoService;

  final MongoService _mongoService;

  @override
  Future<User?> findByEmail({required String email}) async {
    final userMap =
        await _mongoService.db.collection('users').findOne({'email': email});
    if (userMap == null) {
      return null;
    } else {
      return User.fromJson(userMap);
    }
  }

  @override
  Future<WriteResult> insertOne({required User user}) async {
    return _mongoService.db.collection('users').insertOne(user.toJson());
  }
}
