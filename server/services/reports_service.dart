import 'package:models/models.dart';

import '../repositories/reports_repository.dart';
import 'settlements_service.dart';

abstract class ReportsService {
  Future<List<ReportBrief>> createReportsBrief(
      {required String userId, required SettlementService settlementService});

  Future<Report> fetchReportById(
      {required String reportId, required String userId});

  Future<void> deleteById(String id, String userId);
}

class ReportsServiceImpl implements ReportsService {
  ReportsServiceImpl({required ReportsRepository reportsRepository})
      : _reportsRepository = reportsRepository;
  final ReportsRepository _reportsRepository;

  @override
  Future<Report> fetchReportById(
          {required String reportId, required String userId}) =>
      _reportsRepository.fetchReportById(reportId: reportId, userId: userId);

  @override
  Future<void> deleteById(String id, String userId) =>
      _reportsRepository.deleteById(reportId: id, userId: userId);

  @override
  Future<List<ReportBrief>> createReportsBrief({
    required String userId,
    required SettlementService settlementService,
  }) async {
    final cache = <String, Settlement>{};
    final originalReports =
        await _reportsRepository.fetchReportsBriefByUserId(userId: userId);
    final briefs = <ReportBrief>[];
    for (final report in originalReports) {
      final ownerIndex = report.reportOwners.indexOf(userId);
      if (report.state[ownerIndex] == 2) {
        continue;
      }
      final brief = ReportBrief(
        id: report.id!.$oid,
        read: report.state[ownerIndex] != 0,
        title: await _createTitle(cache, report, settlementService),
        received: report.dateTime,
      );
      briefs.add(brief);
    }
    briefs.sort(
      (a, b) => b.received.compareTo(a.received),
    );
    return briefs;
  }

  Future<String> _createTitle(
    Map<String, Settlement> cache,
    Report report,
    SettlementService settlementService,
  ) async {
    late Settlement? from;
    late Settlement? to;
    if (cache.containsKey(report.off.settlementId)) {
      from = cache[report.off.settlementId];
    } else {
      from = await settlementService.fetchSettlementById(
        settlementId: report.off.settlementId,
      );
      cache.putIfAbsent(
        from!.id.$oid,
        () => from!,
      );
    }
    if (cache.containsKey(report.def[0].settlementId)) {
      to = cache[report.def[0].settlementId];
    } else {
      to = await settlementService.fetchSettlementById(
        settlementId: report.def[0].settlementId,
      );
      cache.putIfAbsent(
        to!.id.$oid,
        () => to!,
      );
    }
    return '${from!.name} ${_getMission(report)} ${to!.name}';
  }

  String _getMission(Report reportEntity) {
    String mission;
    if (reportEntity.mission == Mission.reinforcement) {
      mission = "reinforces";
    } else if (reportEntity.mission == Mission.attack) {
      mission = "attacks";
    } else {
      mission = "raids";
    }
    return mission;
  }
}
