import 'package:dartopia/consts/colors.dart';
import 'package:dartopia/reports/reports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key, required this.reportId});

  final String reportId;

  @override
  Widget build(BuildContext context) {
    context.read<ReportsBloc>().add(FetchReportRequested(reportId: reportId));
    return const ReportView();
  }
}

class ReportView extends StatelessWidget {
  const ReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: DartopiaColors.background,
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromRGBO(36, 126, 38, 1.0),
      ),
      body: BlocBuilder<ReportsBloc, ReportsState>(
        builder: (context, state) {
          return state.status == ReportsStatus.loading ||
                  state.currentReport == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ReportBody(report: state.currentReport!, briefs: state.briefs);
        },
      ),
    ));
  }
}
