import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:models/models.dart';

import '../../../consts/images.dart';

class ReportBody extends StatelessWidget {
  const ReportBody({super.key, required this.report, required this.briefs});

  final MilitaryReportResponse report;
  final List<ReportBrief> briefs;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: SingleChildScrollView(
      child: Column(
        children: [
          report.off != null
              ? _buildHeader(context,
                  title:
                      briefs.firstWhere((brief) => brief.id == report.id).title,
                  dateTime: report.dateTime)
              : _buildHeader(context,
                  title:
                      'Reinforcement in ${report.def!.settlementName} has been attacked',
                  dateTime: report.dateTime),
          const Divider(),
          report.off != null
              ? _buildSide(context,
                  playerInfo: report.off!,
                  playerRole: 'ATTACKER',
                  color: const Color(0xFFA33F41),
                  bountyData: report.failed ? null : report.bounty)
              : const SizedBox(),
          report.failed
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'None of the attacker troops returned',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: const Color(0xFFA33F41)),
                  ),
                )
              : const SizedBox(),
          report.failed
              ? _buildEmpty(context,
                  playerInfo: report.def!, color: const Color(0xFF6A9AB8))
              : report.off != null
                  ? _buildSide(context,
                      playerInfo: report.def!,
                      playerRole: 'DEFENDER',
                      color: const Color(0xFF6A9AB8))
                  : const SizedBox(),
          ...report.failed
              ? []
              : report.reinforcements.map((r) => _buildReinforcement(context,
                  playerInfo: r, color: const Color(0xFF6AA852))),
          const Divider(),
          const SizedBox(
            height: 50,
          )
        ],
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

  Widget _buildEmpty(BuildContext context,
      {required PlayerInfo playerInfo, required Color color}) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          /*color: Color(0xFFA33F41),*/
          color: color,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: Text(
              'DEFENCE',
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
                  units: List.generate(10, (i) => 0),
                  maxWidth: constraints.maxWidth),
              _unitsRow(
                  units: List.generate(10, (i) => 0),
                  hidden: true,
                  maxWidth: constraints.maxWidth),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSide(BuildContext context,
      {required PlayerInfo playerInfo,
      required String playerRole,
      List<int>? bountyData,
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
        bountyData != null
            ? _bountyBar(playerInfo, bountyData)
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

  Widget _unitsRow(
      {required List<int> units,
      bool hidden = false,
      required double maxWidth}) {
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
                    hidden ? '?' : '$e',
                    overflow: TextOverflow.ellipsis,
                  )),
                ))
            .toList(),
      ],
    );
  }

  Widget _bountyBar(PlayerInfo playerInfo, List<int> bounty) {
    final bountySum = bounty.reduce((a, b) => a + b);
    final aliveUnits = List.generate(playerInfo.units.length,
        (index) => playerInfo.units[index] - playerInfo.casualty[index]);
    final maxBounty = _countMaxCapacity(aliveUnits);
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

  Widget _buildReinforcement(BuildContext context,
      {required DefenseInfo playerInfo, required Color color}) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: color,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: Text(
              'REINFORCEMENT',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Colors.white),
            ),
          ),
        ),
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
      ],
    );
  }
}
