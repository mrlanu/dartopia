import 'package:dartopia/reports/reports.dart';
import 'package:dartopia/reports/view/report_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class ReportsPage extends StatelessWidget {
  ReportsPage({super.key});

  final ReportsRepository _reportsRepository = ReportsRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => _reportsRepository,
      child: BlocProvider(
        create: (context) => ReportsBloc(reportsRepository: _reportsRepository)
          ..add(const ListOfBriefsRequested(userId: 'Nata')),
        child: const ReportsView(),
      ),
    );
  }
}

class ReportsView extends StatelessWidget {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportsBloc, ReportsState>(
      builder: (context, state) {
        return state.status == ReportsStatus.loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.separated(
                separatorBuilder: (context, index) => const Divider(),
                itemCount: state.briefs.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(state.briefs[index].id),
                    onDismissed: (direction) {
                      final report = state.briefs[index];
                      context.read<ReportsBloc>().add(DeleteReportRequested(
                          reportId: report.id, index: index));
                    },
                    background: Container(
                      color: Colors.deepOrangeAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: const Icon(
                        Icons.delete,
                        color: Color(0xFFE7E7E7),
                      ),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white70,
                          child: FaIcon(state.briefs[index].read
                              ? FontAwesomeIcons.envelopeOpen
                              : FontAwesomeIcons.envelope)),
                      trailing: Text(
                        DateFormat('MM.dd.yy hh:mm')
                            .format(state.briefs[index].received),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      title: Text(
                        state.briefs[index].title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      onTap: () {
                        Navigator.of(context).push(ReportPage.route(
                            reportsBloc: context.read<ReportsBloc>(),
                            reportBrief: state.briefs[index]));
                      },
                    ),
                  );
                },
              );
      },
    );
  }
}
