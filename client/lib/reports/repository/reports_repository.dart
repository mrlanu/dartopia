import 'package:models/models.dart';
import 'package:network/network.dart';

abstract class ReportsRepository {
  Future<(int, List<ReportBrief>)> fetchAllReportsBriefByUserId();

  Future<MilitaryReportResponse> fetchReportById({required String reportId});

  Future<void> deleteReportById({required String reportId});
}

class ReportsRepositoryImpl implements ReportsRepository {
  ReportsRepositoryImpl({NetworkClient? networkClient})
      : _networkClient = networkClient ?? NetworkClient.instance;

  final NetworkClient _networkClient;

  @override
  Future<(int, List<ReportBrief>)> fetchAllReportsBriefByUserId() async {
    try {
      final response = await _networkClient
          .get<Map<String, dynamic>>(Api.fetchAllReportsBrief());
      final result = (response.data!['briefs'] as List<dynamic>)
          .map((e) => ReportBrief.fromJson(e as Map<String, dynamic>))
          .toList();
      return (response.data!['amount'] as int, result);
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
