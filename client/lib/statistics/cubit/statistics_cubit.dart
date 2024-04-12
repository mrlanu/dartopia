import 'package:bloc/bloc.dart';
import 'package:dartopia/statistics/statistics_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

part 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  StatisticsCubit({required StatisticsRepository statisticsRepository})
      : _statisticsRepository = statisticsRepository,
        super(const StatisticsState());

  final StatisticsRepository _statisticsRepository;

  Future<void> fetchStatistics({String? page}) async {
    emit(state.copyWith(statisticsStatus: StatisticsStatus.loading));
    final result = await _statisticsRepository.fetchStatistics(
        page: page, sort: state.sortStat.name);
    emit(state.copyWith(
        statisticsResponse: result,
        statisticsStatus: StatisticsStatus.success));
  }

  Future<void> changeSort(SortStat sortStat) async {
    emit(state.copyWith(sortStat: sortStat));
    fetchStatistics();
  }
}
