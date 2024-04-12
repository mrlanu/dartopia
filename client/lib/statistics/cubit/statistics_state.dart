part of 'statistics_cubit.dart';

enum StatisticsStatus {
  loading,
  success,
  failure,
}

enum SortStat {overview, attacker, defender, top}

extension SortStatX on SortStat {
  String get name {
    return switch(this){
      SortStat.overview => 'population',
      SortStat.attacker => 'attackPoint',
      SortStat.defender => 'defensePoint',
      SortStat.top => 'top',
    };
  }
}

class StatisticsState extends Equatable {
  const StatisticsState(
      {this.page,
      this.sortStat = SortStat.overview,
      this.statisticsResponse,
      this.statisticsStatus = StatisticsStatus.loading});

  final int? page;
  final SortStat sortStat;
  final StatisticsResponse? statisticsResponse;
  final StatisticsStatus statisticsStatus;

  StatisticsState copyWith({
    int? page,
    SortStat? sortStat,
    StatisticsResponse? statisticsResponse,
    StatisticsStatus? statisticsStatus,
  }) {
    return StatisticsState(
      page: page ?? this.page,
      sortStat: sortStat ?? this.sortStat,
      statisticsResponse: statisticsResponse ?? this.statisticsResponse,
      statisticsStatus: statisticsStatus ?? this.statisticsStatus,
    );
  }

  @override
  List<Object?> get props => [page, sortStat, statisticsResponse, statisticsStatus];
}
