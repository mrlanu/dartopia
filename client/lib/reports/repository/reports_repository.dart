import 'package:models/models.dart';
import 'package:network/network.dart';
import 'package:rxdart/rxdart.dart';

abstract class ReportsRepository {
  Stream<(int, List<ReportBrief>)> unreadReportsAmountAndBriefs();

  Future<void> fetchAllReportsBriefByUserId();

  Future<MilitaryReportResponse> fetchReportById({required String reportId});

  Future<void> deleteReportById({required String reportId});
}

class ReportsRepositoryImpl implements ReportsRepository {
  ReportsRepositoryImpl({NetworkClient? networkClient})
      : _networkClient = networkClient ?? NetworkClient.instance;

  final NetworkClient _networkClient;
  final _unreadReportsAmountAndBriefsController =
      BehaviorSubject<(int, List<ReportBrief>)>.seeded((0, []));

  @override
  Stream<(int, List<ReportBrief>)> unreadReportsAmountAndBriefs() =>
      _unreadReportsAmountAndBriefsController.asBroadcastStream();

  @override
  Future<void> fetchAllReportsBriefByUserId() async {
    try {
      final response = await _networkClient
          .get<Map<String, dynamic>>(Api.fetchAllReportsBrief());
      final result = (response.data!['briefs'] as List<dynamic>)
          .map((e) => ReportBrief.fromJson(e as Map<String, dynamic>))
          .toList();
      _unreadReportsAmountAndBriefsController
          .add((response.data!['amount'] as int, result));
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  @override
  Future<MilitaryReportResponse> fetchReportById(
      {required String reportId}) async {
    try {
      final response = await _networkClient
          .get<Map<String, dynamic>>(Api.fetchReportById(reportId));
      final report = MilitaryReportResponse.fromJson(response.data!);
      return report;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  @override
  Future<void> deleteReportById({required String reportId}) async {
    try {
      _networkClient.delete(Api.deleteReportById(reportId));
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }
}
