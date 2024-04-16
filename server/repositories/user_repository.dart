import 'package:models/models.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../database/database_client.dart';
import '../exceptions/exceptions.dart';

abstract class UserRepository {
  Future<User?> findByEmail({required String email});
  Future<User?> findById({required String id});

  Future<WriteResult> insertOne({required User user});
}

class UserRepositoryMongo extends UserRepository {
  UserRepositoryMongo({required DatabaseClient databaseClient})
      : _databaseClient = databaseClient;

  final DatabaseClient _databaseClient;

  @override
  Future<User?> findByEmail({required String email}) async {
    try {
      if (_databaseClient.db != null && _databaseClient.db!.isConnected) {
        final userMap = await _databaseClient.db!
            .collection('users')
            .findOne({'email': email});
        if (userMap == null) {
          throw NoUserFoundException();
        } else {
          return User.fromJson(userMap);
        }
      } else {
        throw DatabaseConnectionException();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User?> findById({required String id}) async {
    try {
      if (_databaseClient.db != null && _databaseClient.db!.isConnected) {
        final userMap = await _databaseClient.db!
            .collection('users')
            .findOne(where.eq('_id', id));
        if (userMap == null) {
          throw NoUserFoundException();
        } else {
          return User.fromJson(userMap);
        }
      } else {
        throw DatabaseConnectionException();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<WriteResult> insertOne({required User user}) async {
    try {
      if (_databaseClient.db != null && _databaseClient.db!.isConnected) {
        return _databaseClient.db!.collection('users').insertOne(user.toJson());
      } else {
        throw DatabaseConnectionException();
      }
    } catch (e) {
      rethrow;
    }
  }
}
