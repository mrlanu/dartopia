import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:models/src/statistics/statistics.dart';

part 'statistics_response.freezed.dart';

part 'statistics_response.g.dart';

@freezed
class StatisticsResponse with _$StatisticsResponse {
  const factory StatisticsResponse({
    required List<StatisticsModel> modelsList,
    required String currentPage,
    required String totalItems,
    required String totalPages,
    required String itemsPerPage,
  }) = _StatisticsResponse;

  factory StatisticsResponse.fromJson(Map<String, dynamic> json) =>
      _$StatisticsResponseFromJson(json);
}
