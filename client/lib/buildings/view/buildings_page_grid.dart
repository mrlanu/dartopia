import 'package:dartopia/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

import '../../building_detail/view/building_detail_page.dart';
import '../../settlement/bloc/settlement_bloc.dart';
import '../../storage_bar/view/storage_bar.dart';
import '../../utils/countdown.dart';
import '../buildings.dart';

class BuildingsPageGrid extends StatelessWidget {
  const BuildingsPageGrid(
      {super.key, required this.settlement, required this.buildingRecords});

  final Settlement settlement;
  final List<List<int>> buildingRecords;

  @override
  Widget build(BuildContext context) {
    return BuildingsGridView(
      settlement: settlement,
      buildingRecords: buildingRecords,
    );
  }
}

class BuildingsGridView extends StatefulWidget {
  const BuildingsGridView(
      {super.key, required this.settlement, required this.buildingRecords});

  final List<List<int>> buildingRecords;
  final Settlement settlement;

  @override
  State<BuildingsGridView> createState() => _BuildingsGridViewState();
}

class _BuildingsGridViewState extends State<BuildingsGridView> {
  @override
  Widget build(BuildContext context) {
    final emptySpots =
        widget.buildingRecords.where((bR) => bR[1] == 99).toList();
    return Column(
      children: [
        const SizedBox(
          height: 3,
        ),
        StorageBar(
          settlement: widget.settlement,
        ),
        Expanded(
          child: ReorderableGridView.count(
            padding: const EdgeInsets.all(10),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 3,
            dragWidgetBuilder: (index, child) {
              return Card(
                color: const Color.fromRGBO(36, 126, 38, 1.0),
                child: child,
              );
            },
            onReorder: (oldIndex, newIndex) {
              setState(() {
                final element = widget.buildingRecords.removeAt(oldIndex);
                widget.buildingRecords.insert(newIndex, element);
              });
            },
            header: widget.buildingRecords
                .where((bR) =>
                    bR[1] == 0 || bR[1] == 1 || bR[1] == 2 || bR[1] == 3)
                .map(
              (fieldRecord) {
                final constructionTasks = widget.settlement.constructionTasks
                    .where((task) => task.buildingId == fieldRecord[1])
                    .toList();
                return _BuildingGridItem(
                  key: ValueKey('${fieldRecord[0]} ${fieldRecord[1]}'),
                  buildingRecord: fieldRecord,
                  constructionTask: constructionTasks.lastOrNull,
                  prodPerHour: widget.settlement.calculateProducePerHour(),
                );
              },
            ).toList(),
            footer: [
              _BuildingGridAddItem(
                  key: UniqueKey(),
                  emptySpots: emptySpots,
                  labelBackground: Colors.deepOrangeAccent),
            ],
            children: widget.buildingRecords
                .where((bR) =>
                    bR[1] != 99 &&
                    bR[1] != 0 &&
                    bR[1] != 1 &&
                    bR[1] != 2 &&
                    bR[1] != 3)
                .map(
              (bRecord) {
                final upgradingTasks = widget.settlement.constructionTasks
                    .where((task) => task.position == bRecord[0])
                    .toList();
                return _BuildingGridItem(
                  key: ValueKey('${bRecord[0]} ${bRecord[1]}'),
                  buildingRecord: bRecord,
                  constructionTask: upgradingTasks.lastOrNull,
                );
              },
            ).toList(),
          ),
        ),
      ],
    );
  }
}

class _BuildingGridItem extends StatelessWidget {
  const _BuildingGridItem({
    super.key,
    required this.buildingRecord,
    this.constructionTask,
    this.prodPerHour = const [0, 0, 0, 0],
  });

  final List<int> buildingRecord;
  final ConstructionTask? constructionTask;
  final List<int> prodPerHour;

  @override
  Widget build(BuildContext context) {
    final labelBackground = constructionTask == null
        ? primary
        : const Color.fromRGBO(253, 216, 87, 1.0);
    final labelColor = constructionTask == null ? Colors.white : Colors.black;
    final id = buildingRecord[1];
    final lbl = id == 0 || id == 1 || id == 2 || id == 3
        ? prodPerHour[id].toString()
        : 'lvl ${buildingRecord[2]}';
    return Badge(
      label: Text(lbl),
      backgroundColor: labelBackground,
      textColor: labelColor,
      textStyle: Theme.of(context).textTheme.bodyMedium,
      offset: Offset(-1.0 * lbl.length, 0),
      largeSize: 22,
      smallSize: 0,
      child: Badge(
        alignment: Alignment.bottomLeft,
        label: _buildLabel(labelColor, context),
        textColor: labelColor,
        backgroundColor: labelBackground,
        offset: const Offset(0, 0),
        textStyle: Theme.of(context).textTheme.bodyMedium,
        largeSize: 22,
        child: GestureDetector(
          onTap: () {
            final settlementBloc = context.read<SettlementBloc>();
            Navigator.of(context).push(BuildingDetailPage.route(
                block: settlementBloc, buildingRecord: buildingRecord));
          },
          child: Card(
            color: background3,
            child: BuildingPicture(
              buildingRecord: buildingRecord,
              prodPerHour: null,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(Color labelColor, BuildContext context) {
    return constructionTask == null
        ? Text(buildingSpecefication[buildingRecord[1]]!.name)
        : Row(
            children: [
              Text(buildingSpecefication[constructionTask!.buildingId]!.name),
              const SizedBox(width: 5),
              CountdownTimer(
                startValue: constructionTask!.executionTime
                    .difference(DateTime.now())
                    .inSeconds,
                onFinish: () {
                  context
                      .read<SettlementBloc>()
                      .add(const SettlementFetchRequested());
                },
                textStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: labelColor),
              ),
            ],
          );
  }
}

class _BuildingGridAddItem extends StatelessWidget {
  const _BuildingGridAddItem(
      {super.key, required this.emptySpots, this.labelBackground = primary});

  final List<List<int>> emptySpots;
  final Color labelBackground;

  @override
  Widget build(BuildContext context) {
    final settlementBloc = context.read<SettlementBloc>();
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(BuildingDetailPage.route(
            block: settlementBloc, buildingRecord: emptySpots.first));
      },
      child: Badge(
        alignment: Alignment.bottomRight,
        label: Text(emptySpots.length.toString()),
        backgroundColor: labelBackground,
        textStyle: Theme.of(context).textTheme.bodyMedium,
        offset: const Offset(5, 0),
        largeSize: 22,
        child: const Card(
          color: background3,
          child: Center(
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
