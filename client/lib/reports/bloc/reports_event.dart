part of 'reports_bloc.dart';

sealed class ReportsEvent extends Equatable {
  const ReportsEvent();
}

final class ListOfBriefsRequested extends ReportsEvent {
  const ListOfBriefsRequested({required this.userId});

  final String userId;

  @override
  List<Object?> get props => [userId];
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