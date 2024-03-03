import 'package:models/models.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../database/database_client.dart';
import '../exceptions/exceptions.dart';

abstract class ReportsRepository {
  Future<List<ReportEntity>> fetchAllReportsByUserId({required String userId});

  Future<ReportEntity> fetchReportById({
    required String reportId,
    required String userId,
  });

  Future<void> deleteById({required String reportId, required String userId});
}

class ReportsRepositoryMongoImpl implements ReportsRepository {
  ReportsRepositoryMongoImpl({required DatabaseClient databaseClient})
      : _databaseClient = databaseClient;

  final DatabaseClient _databaseClient;

  @override
  Future<List<ReportEntity>> fetchAllReportsByUserId({
    required String userId,
  }) {
    try {
      if (_databaseClient.db != null && _databaseClient.db!.isConnected) {
        final result = _databaseClient.db!
            .collection('reports')
            .find(where.eq('reportOwners', userId))
            .map(ReportEntity.fromMap)
            .toList();
        return result;
      } else {
        throw DatabaseConnectionException();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ReportEntity> fetchReportById({
    required String reportId,
    required String userId,
  }) async {
    final objectId = ObjectId.parse(reportId);
    try {
      if (_databaseClient.db != null && _databaseClient.db!.isConnected) {
        final document = await _databaseClient.db!
            .collection('reports')
            .findOne(where.id(objectId));
        final report = ReportEntity.fromMap(document!);
        final ownerIndex = report.reportOwners.indexOf(userId);
        final state = [...report.state];
        state[ownerIndex] = 1;
        await _databaseClient.db!.collection('reports').replaceOne(
            where.id(objectId), report.copyWith(state: state).toMap(),);
        return report.copyWith(state: state);
      } else {
        throw DatabaseConnectionException();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteById({
    required String reportId,
    required String userId,
  }) async {
    final objectId = ObjectId.parse(reportId);
    try {
      if (_databaseClient.db != null && _databaseClient.db!.isConnected) {
        final document = await _databaseClient.db!
            .collection('reports')
            .findOne(where.id(objectId));
        final report = ReportEntity.fromMap(document!);
        final ownerIndex = report.reportOwners.indexOf(userId);
        final state = [...report.state];
        state[ownerIndex] = 2;
        final isAllDeleted = !state.any((element) => element != 2);
        isAllDeleted
            ? _databaseClient.db!
                .collection('reports')
                .deleteOne(where.id(objectId))
            : await _databaseClient.db!.collection('reports').replaceOne(
                  where.id(objectId),
                  report.copyWith(state: state).toMap(),
                );
      } else {
        throw DatabaseConnectionException();
      }
    } catch (e) {
      rethrow;
    }
  }
}
