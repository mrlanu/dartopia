import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:models/src/statistics/statistics.dart';

part 'statistics_response.freezed.dart';

part 'statistics_response.g.dart';

@freezed
class StatisticsResponse with _$StatisticsResponse {
  const factory StatisticsResponse({
    required List<StatisticsModel> modelsList,
    required int currentPage,
    required int totalItems,
    required int totalPages,
    required int itemsPerPage,
  }) = _StatisticsResponse;

  factory StatisticsResponse.fromJson(Map<String, dynamic> json) =>
      _$StatisticsResponseFromJson(json);
}
