import 'package:models/models.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../services/mongo_service.dart';

abstract class ReportsRepository {
  Future<List<Report>> fetchReportsBriefByUserId({required String userId});

  Future<Report> fetchReportById(
      {required String reportId, required String userId});

  Future<void> deleteById(
      {required String reportId, required String userId});
}

class ReportsRepositoryMongoImpl implements ReportsRepository {
  ReportsRepositoryMongoImpl({MongoService? mongoService})
      : _mongoService = mongoService ?? MongoService.instance;

  final MongoService _mongoService;

  @override
  Future<List<Report>> fetchReportsBriefByUserId({
    required String userId,
  }) =>
      _mongoService.db
          .collection('reports')
          .find(where.eq('reportOwners', userId))
          .map(Report.fromMap)
          .toList();

  @override
  Future<Report> fetchReportById(
      {required String reportId, required String userId}) async {
    final objectId = ObjectId.parse(reportId);
    final document = await _mongoService.db
        .collection('reports')
        .findOne(where.id(objectId));
    final report = Report.fromMap(document!);
    final ownerIndex = report.reportOwners.indexOf(userId);
    final state = [...report.state];
    state[ownerIndex] = 1;
    await _mongoService.db
        .collection('reports')
        .replaceOne(where.id(objectId), report.copyWith(state: state).toMap());
    return report.copyWith(state: state);
  }

  @override
  Future<void> deleteById(
      {required String reportId, required String userId}) async {
    final objectId = ObjectId.parse(reportId);
    final document = await _mongoService.db
        .collection('reports')
        .findOne(where.id(objectId));
    final report = Report.fromMap(document!);
    final ownerIndex = report.reportOwners.indexOf(userId);
    final state = [...report.state];
    state[ownerIndex] = 2;
    final isAllDeleted = !state.any((element) => element != 2);
    isAllDeleted
        ? _mongoService.db.collection('reports').deleteOne(where.id(objectId))
        : await _mongoService.db.collection('reports').replaceOne(
            where.id(objectId), report.copyWith(state: state).toMap());
  }
}
