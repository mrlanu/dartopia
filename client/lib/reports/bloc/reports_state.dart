part of 'reports_bloc.dart';

enum ReportsStatus {
  loading,
  success,
  failed,
}

class ReportsState extends Equatable {
  const ReportsState(
      {this.status = ReportsStatus.loading,
      this.briefs = const [],
      this.currentReport});

  final ReportsStatus status;
  final List<ReportBrief> briefs;
  final Report? currentReport;

  ReportsState copyWith(
      {ReportsStatus? status,
      List<ReportBrief>? briefs,
      Report? currentReport}) {
    return ReportsState(
        status: status ?? this.status,
        briefs: briefs ?? this.briefs,
        currentReport: currentReport ?? this.currentReport);
  }

  @override
  List<Object?> get props => [status, briefs, currentReport];
}
