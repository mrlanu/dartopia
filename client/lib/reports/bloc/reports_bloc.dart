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
  }

  final ReportsRepository _reportsRepository;

  Future<void> _onListOfBriefsRequested(
    ListOfBriefsRequested event,
    Emitter<ReportsState> emit,
  ) async {
    emit(state.copyWith(status: ReportsStatus.loading));
    final briefs = await _reportsRepository.fetchAllReportsBriefByUserId();
    emit(state.copyWith(status: ReportsStatus.success, briefs: briefs));
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
    briefs.removeAt(event.index);
    emit(state.copyWith(briefs: briefs));
    _reportsRepository.deleteReportById(reportId: event.reportId);
  }
}
