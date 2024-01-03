import 'dart:convert';

import 'package:models/models.dart';
import 'package:http/http.dart' as http;

import '../../consts/api.dart';

abstract class ReportsRepository {
  Future<List<ReportBrief>> fetchAllReportsBriefByUserId({required String userId});
  Future<Report> fetchReportById({required String reportId});

  Future<void> deleteReportById({required String reportId});
}

class ReportsRepositoryImpl implements ReportsRepository{
  @override
  Future<List<ReportBrief>> fetchAllReportsBriefByUserId({required String userId}) async {
    final url = Uri.http(Api.baseURL, Api.fetchAllReportsBriefByUserId(userId), {'userId': userId});
    final response = await http.get(url);
    final responseList = json.decode(response.body) as List<dynamic>;
    final result = responseList
        .map((e) => ReportBrief.fromJson(e as Map<String, dynamic>))
        .toList();
    return result;
  }

  @override
  Future<Report> fetchReportById({required String reportId}) async {
    final url = Uri.http(Api.baseURL, Api.fetchReportById(reportId), {'userId': 'Nata'});
    final response = await http.get(url);
    final map = json.decode(response.body) as Map<String, dynamic>;
    final report = Report.fromJson(map);
    return report;
  }

  @override
  Future<void> deleteReportById({required String reportId}) async {
    final url = Uri.http(Api.baseURL, Api.deleteReportById(reportId), {'userId': 'Nata'});
    http.delete(url);
  }
}
