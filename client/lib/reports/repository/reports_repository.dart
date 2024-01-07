import 'dart:convert';

import 'package:models/models.dart';
import 'package:http/http.dart' as http;

abstract class ReportsRepository {
  Future<List<ReportBrief>> fetchAllReportsBriefByUserId();

  Future<Report> fetchReportById({required String reportId});

  Future<void> deleteReportById({required String reportId});
}

class ReportsRepositoryImpl implements ReportsRepository {

  ReportsRepositoryImpl({required String token}): _token = token;

  final String _token;

  @override
  Future<List<ReportBrief>> fetchAllReportsBriefByUserId() async {
    final url = Uri.http(Api.baseURL, Api.fetchAllReportsBrief());
    final response = await http.get(url, headers: Api.headerAuthorization(token: _token));
    final responseList = json.decode(response.body) as List<dynamic>;
    final result = responseList
        .map((e) => ReportBrief.fromJson(e as Map<String, dynamic>))
        .toList();
    return result;
  }

  @override
  Future<Report> fetchReportById({required String reportId}) async {
    final url = Uri.http(
        Api.baseURL, Api.fetchReportById(reportId));
    final response = await http.get(url, headers: Api.headerAuthorization(token: _token));
    final map = json.decode(response.body) as Map<String, dynamic>;
    final report = Report.fromJson(map);
    return report;
  }

  @override
  Future<void> deleteReportById({required String reportId}) async {
    final url = Uri.http(
        Api.baseURL, Api.deleteReportById(reportId));
    http.delete(url, headers: Api.headerAuthorization(token: _token));
  }
}
