part of 'reports_bloc.dart';

sealed class ReportsEvent extends Equatable {
  const ReportsEvent();
}

final class ListOfBriefsRequested extends ReportsEvent {
  const ListOfBriefsRequested();

  @override
  List<Object?> get props => [];
}

final class DeleteReportRequested extends ReportsEvent {
  const DeleteReportRequested({required this.reportId, required this.index});

  final String reportId;
  final int index;

  @override
  List<Object?> get props => [reportId, index];
}

final class FetchReportRequested extends ReportsEvent {
  const FetchReportRequested({required this.reportId});

  final String reportId;

  @override
  List<Object?> get props => [reportId];
}

final class AmountSubtractRequested extends ReportsEvent {
  const AmountSubtractRequested({required this.index});

  final int index;

  @override
  List<Object?> get props => [index];
}
