import 'package:dartopia/consts/consts.dart';
import 'package:dartopia/reports/reports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:models/models.dart';

import '../../consts/images.dart';

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
              : Card(
                  child: Column(
                  children: [
                    _buildHeader(context,
                        title: state.briefs
                            .firstWhere((brief) =>
                                brief.id == state.currentReport!.id!.$oid)
                            .title,
                        dateTime: state.currentReport!.dateTime),
                    const Divider(),
                    _buildSide(context,
                        playerInfo: state.currentReport!.off!,
                        playerRole: 'ATTACKER',
                        color: const Color(0xFFA33F41)),
                    _buildSide(context,
                        playerInfo: state.currentReport!.def!,
                        playerRole: 'DEFENDER',
                        bountyBar: false,
                        color: const Color(0xFF6A9AB8)),
                    ...state.currentReport!.reinforcements
                        .map((r) => _buildSide(context,
                            playerInfo: r,
                            playerRole: 'REINFORCEMENT',
                            bountyBar: false,
                            color: const Color(0xFF6AA852)))
                        .toList()
                  ],
                ));
        },
      ),
    ));
  }

  Widget _buildHeader(BuildContext context,
      {required String title, required DateTime dateTime}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('MM.dd.yy hh:mm').format(dateTime),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Row(
                children: [
                  IconButton.outlined(
                      color: Colors.green,
                      onPressed: () {},
                      icon: const Icon(
                        Icons.arrow_back,
                      )),
                  IconButton.outlined(
                      color: Colors.green,
                      onPressed: () {},
                      icon: const Icon(
                        Icons.arrow_forward,
                      )),
                  IconButton.outlined(
                      color: Colors.green,
                      onPressed: () {},
                      icon: const Icon(
                        Icons.delete,
                      )),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSide(BuildContext context,
      {required PlayerInfo playerInfo,
      required String playerRole,
      bool bountyBar = true,
      required Color color}) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          /*color: Color(0xFFA33F41),*/
          color: color,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: Text(
              playerRole,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Colors.white),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              '${playerInfo.playerName} from village ${playerInfo.settlementName}',
              style: Theme.of(context).textTheme.titleMedium),
        ),
        const Divider(),
        LayoutBuilder(
          builder: (context, constraints) => Column(
            children: [
              _iconsRow(
                  units: playerInfo.units, maxWidth: constraints.maxWidth),
              _unitsRow(
                  units: playerInfo.units, maxWidth: constraints.maxWidth),
              _unitsRow(
                  units: playerInfo.casualty, maxWidth: constraints.maxWidth),
            ],
          ),
        ),
        bountyBar
            ? _bountyBar(playerInfo.units, playerInfo.bounty)
            : const SizedBox(),
        const Divider(),
      ],
    );
  }

  Widget _iconsRow({required List<int> units, required double maxWidth}) {
    return Row(
      children: [
        SizedBox(
          width: maxWidth * 0.1,
          height: 22,
          child: const Center(child: Text('')),
        ),
        ...units
            .asMap()
            .entries
            .map((e) => SizedBox(
                  width: (maxWidth - maxWidth * 0.1) / 10,
                  height: 22,
                  child: Center(
                    child: Container(
                      width: 16.0,
                      height: 16.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          alignment: Alignment(-1.0 + 0.224 * e.key, 0.0),
                          image: const AssetImage(DartopiaImages.troops),
                          // Replace with your actual image path
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ))
            .toList(),
      ],
    );
  }

  Widget _unitsRow({required List<int> units, required double maxWidth}) {
    return Row(
      children: [
        SizedBox(
          width: maxWidth * 0.1,
          height: 22,
          child: const Center(child: Text('T')),
        ),
        ...units
            .map((e) => SizedBox(
                  width: (maxWidth - maxWidth * 0.1) / 10,
                  height: 22,
                  child: Center(
                      child: Text(
                    '$e',
                    overflow: TextOverflow.ellipsis,
                  )),
                ))
            .toList(),
      ],
    );
  }

  Widget _bountyBar(List<int> units, List<int> bounty) {
    final bountySum = bounty.reduce((a, b) => a + b);
    final maxBounty = _countMaxCapacity(units);
    final bagOffset = bountySum > 0 ? (bountySum >= maxBounty ? 2 : 1) : 0;
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Row(
        children: [
          Container(
            width: 13.0,
            height: 13.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                alignment: Alignment(0.0, -1.0 + 0.67 * bagOffset),
                image: const AssetImage(DartopiaImages.carry),
                // Replace with your actual image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            width: 7,
          ),
          Text('$bountySum/$maxBounty'),
        ],
      ),
      const SizedBox(
        width: 30,
      ),
      Row(children: [
        Image.asset(
          DartopiaImages.lumber,
          width: 40,
          height: 40,
        ),
        Text(
          '${bounty[0]}',
        )
      ]),
      Row(children: [
        Image.asset(
          DartopiaImages.clay,
          width: 40,
          height: 40,
        ),
        Text(
          '${bounty[1]}',
        )
      ]),
      Row(children: [
        Image.asset(
          DartopiaImages.iron,
          width: 40,
          height: 40,
        ),
        Text(
          '${bounty[2]}',
        ),
        Row(children: [
          Image.asset(
            DartopiaImages.crop,
            width: 40,
            height: 40,
          ),
          Text(
            '${bounty[3]}',
          )
        ]),
      ])
    ]);
  }

  int _countMaxCapacity(List<int> units) {
    var result = 0;
    final unitsSpecifications = UnitsConst.UNITS[2];
    for (var i = 0; i < units.length; i++) {
      result = result + unitsSpecifications[i].capacity * units[i];
    }
    return result;
  }
}
