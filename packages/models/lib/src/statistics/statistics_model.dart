import 'package:freezed_annotation/freezed_annotation.dart';

part 'statistics_model.freezed.dart';
part 'statistics_model.g.dart';

@freezed
class StatisticsModel with _$StatisticsModel {

  const factory StatisticsModel({
    int? position,
    required String playerId,
    required String playerName,
    required String allianceName,
    @Default(0) int population,
    @Default(1) int villagesAmount,
    @Default(0) int attackPoint,
    @Default(0) int defensePoint,}) = _StatisticsModel;

  factory StatisticsModel.fromJson(Map<String, dynamic> json) =>
      _$StatisticsModelFromJson(json);
}
