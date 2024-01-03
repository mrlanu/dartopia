import 'package:dartopia/consts/consts.dart';
import 'package:dartopia/reports/reports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  static Route<void> route(
      {required ReportsBloc reportsBloc, required ReportBrief reportBrief}) {
    return MaterialPageRoute(builder: (context) {
      return BlocProvider.value(
        value: reportsBloc..add(FetchReportRequested(reportId: reportBrief.id)),
        child: const ReportPage(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const ReportView();
  }
}

class ReportView extends StatelessWidget {
  const ReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: background,
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
              : Center(child: Text('REPORT: ${state.currentReport!.id!.$oid}'));
        },
      ),
    ));
  }
}
