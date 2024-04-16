import 'package:models/models.dart';

import '../repositories/reports_repository.dart';
import 'settlements_service.dart';

abstract class ReportsService {
  Future<(int, List<ReportBrief>)> createReportsBrief(
      {required String playerId, required SettlementService settlementService});

  Future<MilitaryReportResponse> fetchReportById(
      {required String reportId, required String playerId});

  Future<void> deleteById(String id, String userId);
}

class ReportsServiceImpl implements ReportsService {
  ReportsServiceImpl({required ReportsRepository reportsRepository})
      : _reportsRepository = reportsRepository;
  final ReportsRepository _reportsRepository;

  @override
  Future<MilitaryReportResponse> fetchReportById({
    required String reportId,
    required String playerId,
  }) async {
    final reportEntity = await _reportsRepository.fetchReportById(
        reportId: reportId, playerId: playerId);
    //report for off
    if (reportEntity.reportOwners[0].playerId == playerId) {
      final units = reportEntity.participants[0].units;
      final casualty = reportEntity.participants[0].casualty;
      final isFailedReport = List.generate(10, (i) => units[i] - casualty[i])
              .reduce((a, b) => a + b) == 0;
      return isFailedReport
          ? MilitaryReportResponse.failed(reportEntity)
          : MilitaryReportResponse.full(reportEntity);
    }
    //report for def
    if (reportEntity.reportOwners[1].playerId == playerId) {
      return MilitaryReportResponse.full(reportEntity);
    }
    //report for reinforcement
    final reinforcementIndex = reportEntity.reportOwners
            .indexWhere((owner) => owner.playerId == playerId);
    return MilitaryReportResponse.reinforcement(
        reportEntity, reinforcementIndex);
  }

  @override
  Future<void> deleteById(String id, String playerId) =>
      _reportsRepository.deleteById(reportId: id, playerId: playerId);

  @override
  Future<(int, List<ReportBrief>)> createReportsBrief({
    required String playerId,
    required SettlementService settlementService,
  }) async {
    final cache = <String, Settlement>{};
    final originalReports =
        await _reportsRepository.fetchAllReportsByUserId(playerId: playerId);
    final amountUnreadReports =
        _countUnreadReports(reports: originalReports, playerId: playerId);
    final briefs = <ReportBrief>[];
    for (final report in originalReports) {
      if (report.reportOwners.getReportStatus(playerId) == 2) {
        continue;
      }
      final brief = ReportBrief(
        id: report.id!,
        read: report.reportOwners.getReportStatus(playerId) != 0,
        title: await _createTitle(cache, report, settlementService),
        received: report.dateTime,
      );
      briefs.add(brief);
    }
    briefs.sort(
      (a, b) => b.received.compareTo(a.received),
    );
    return (amountUnreadReports, briefs);
  }

  int _countUnreadReports(
      {required List<ReportEntity> reports, required String playerId}) {
    if (reports.isNotEmpty) {
      return reports
          .where(
              (report) => report.reportOwners.findById(playerId)!.status == 0)
          .length;
    }
    return 0;
  }

  Future<String> _createTitle(
    Map<String, Settlement> cache,
    ReportEntity report,
    SettlementService settlementService,
  ) async {
    late Settlement? from;
    late Settlement? to;
    if (cache.containsKey(report.participants[0].settlementId)) {
      from = cache[report.participants[0].settlementId];
    } else {
      from = await settlementService.fetchSettlementById(
        settlementId: report.participants[0].settlementId,
      );
      cache.putIfAbsent(
        from!.id.$oid,
        () => from!,
      );
    }
    if (cache.containsKey(report.participants[1].settlementId)) {
      to = cache[report.participants[1].settlementId];
    } else {
      to = await settlementService.fetchSettlementById(
        settlementId: report.participants[1].settlementId,
      );
      cache.putIfAbsent(
        to!.id.$oid,
        () => to!,
      );
    }
    return '${from!.name} ${_getMission(report)} ${to!.name}';
  }

  String _getMission(ReportEntity reportEntity) {
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
