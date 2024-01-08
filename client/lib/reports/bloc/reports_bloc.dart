import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

import '../repository/reports_repository.dart';

part 'reports_event.dart';

part 'reports_state.dart';

class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  ReportsBloc({required ReportsRepository reportsRepository})
      : _reportsRepository = reportsRepository,
        super(const ReportsState()) {
    on<ListOfBriefsRequested>(_onListOfBriefsRequested);
    on<FetchReportRequested>(_onFetchReportRequested);
    on<DeleteReportRequested>(_onDeleteReportRequested);
    on<AmountSubtractRequested>(_onAmountSubtractRequested);
  }

  final ReportsRepository _reportsRepository;

  Future<void> _onListOfBriefsRequested(
    ListOfBriefsRequested event,
    Emitter<ReportsState> emit,
  ) async {
    emit(state.copyWith(status: ReportsStatus.loading));
    final briefs = await _reportsRepository.fetchAllReportsBriefByUserId();
    emit(state.copyWith(
        status: ReportsStatus.success, amount: briefs.$1, briefs: briefs.$2));
  }

  Future<void> _onFetchReportRequested(
    FetchReportRequested event,
    Emitter<ReportsState> emit,
  ) async {
    emit(state.copyWith(status: ReportsStatus.loading));
    final report =
        await _reportsRepository.fetchReportById(reportId: event.reportId);
    emit(state.copyWith(status: ReportsStatus.success, currentReport: report));
  }

  Future<void> _onDeleteReportRequested(
    DeleteReportRequested event,
    Emitter<ReportsState> emit,
  ) async {
    final briefs = [...state.briefs];
    final isRead = briefs[event.index].read;
    briefs.removeAt(event.index);
    emit(state.copyWith(briefs: briefs, amount: isRead ? state.amount : state.amount - 1));
    _reportsRepository.deleteReportById(reportId: event.reportId);
  }

  Future<void> _onAmountSubtractRequested(
      AmountSubtractRequested event,
      Emitter<ReportsState> emit,
      ) async {
    final briefs = [...state.briefs];
    briefs[event.index] = briefs[event.index].copyWith(read: true);
    emit(state.copyWith(amount: state.amount - 1, briefs: briefs));
  }
}
