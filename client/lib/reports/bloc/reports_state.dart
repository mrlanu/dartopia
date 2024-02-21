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
        this.amount = 0,
      this.currentReport});

  final ReportsStatus status;
  final List<ReportBrief> briefs;
  final int amount;
  final MilitaryReportResponse? currentReport;

  ReportsState copyWith(
      {ReportsStatus? status,
      List<ReportBrief>? briefs,
        int? amount,
      MilitaryReportResponse? currentReport}) {
    return ReportsState(
        status: status ?? this.status,
        briefs: briefs ?? this.briefs,
        amount: amount ?? this.amount,
        currentReport: currentReport ?? this.currentReport);
  }

  @override
  List<Object?> get props => [status, briefs, amount, currentReport];
}
