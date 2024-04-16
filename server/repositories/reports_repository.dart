import 'package:models/models.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../database/database_client.dart';
import '../exceptions/exceptions.dart';

abstract class ReportsRepository {
  Future<List<ReportEntity>> fetchAllReportsByUserId(
      {required String playerId});

  Future<ReportEntity> fetchReportById({
    required String reportId,
    required String playerId,
  });

  Future<void> deleteById({required String reportId, required String playerId});
}

class ReportsRepositoryMongoImpl implements ReportsRepository {
  ReportsRepositoryMongoImpl({required DatabaseClient databaseClient})
      : _databaseClient = databaseClient;

  final DatabaseClient _databaseClient;

  @override
  Future<List<ReportEntity>> fetchAllReportsByUserId({
    required String playerId,
  }) {
    try {
      if (_databaseClient.db != null && _databaseClient.db!.isConnected) {
        final result = _databaseClient.db!
            .collection('reports')
            .find({
              'reportOwners': {
                r'$elemMatch': {
                  'playerId': playerId,
                },
              },
            })
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
    required String playerId,
  }) async {
    try {
      if (_databaseClient.db != null && _databaseClient.db!.isConnected) {
        final document = await _databaseClient.db!
            .collection('reports')
            .findOne(where.eq('_id', reportId));
        final report = ReportEntity.fromMap(document!);
        final ownerIndex = report.reportOwners.indexWhere(
          (owner) => owner.playerId == playerId,
        );
        final owners = report.reportOwners;
        owners[ownerIndex] = owners[ownerIndex].copyWith(status: 1);
        await _databaseClient.db!.collection('reports').replaceOne(
              where.eq('_id', reportId),
              report.copyWith(reportOwners: owners).toMap(),
            );
        return report.copyWith(reportOwners: owners);
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
    required String playerId,
  }) async {
    try {
      if (_databaseClient.db != null && _databaseClient.db!.isConnected) {
        final document = await _databaseClient.db!
            .collection('reports')
            .findOne(where.eq('_id', reportId));
        final report = ReportEntity.fromMap(document!);
        final ownerIndex = report.reportOwners.indexWhere(
          (owner) => owner.playerId == playerId,
        );
        final owners = report.reportOwners;
        owners[ownerIndex] = owners[ownerIndex].copyWith(status: 2);
        final isAllDeleted = !owners.any((owner) => owner.status != 2);
        isAllDeleted
            ? _databaseClient.db!
                .collection('reports')
                .deleteOne(where.eq('_id', reportId))
            : await _databaseClient.db!.collection('reports').replaceOne(
                  where.eq('_id', reportId),
                  report.copyWith(reportOwners: owners).toMap(),
                );
      } else {
        throw DatabaseConnectionException();
      }
    } catch (e) {
      rethrow;
    }
  }
}
