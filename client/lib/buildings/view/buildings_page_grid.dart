import 'package:dartopia/navigation/navigation.dart';
import 'package:dartopia/consts/colors.dart';
import 'package:dartopia/consts/consts.dart';
import 'package:dartopia/settlement/repository/settlement_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

import '../../settlement/bloc/settlement_bloc.dart';
import '../../storage_bar/view/storage_bar.dart';
import '../../utils/countdown.dart';
import '../buildings.dart';

class BuildingsPageGrid extends StatefulWidget {
  const BuildingsPageGrid({super.key});

  @override
  State<BuildingsPageGrid> createState() => _BuildingsPageGridState();
}

class _BuildingsPageGridState extends State<BuildingsPageGrid> {

  @override
  void initState() {
    super.initState();
    context.read<SettlementBloc>().add(const ListOfSettlementsRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettlementBloc, SettlementState>(
      builder: (context, state) {
        return state.status == SettlementStatus.loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : BuildingsGridView(settlement: state.settlement!);
      },
    );
  }
}

class BuildingsGridView extends StatefulWidget {
  const BuildingsGridView({super.key, required this.settlement});

  final Settlement settlement;

  @override
  State<BuildingsGridView> createState() => _BuildingsGridViewState();
}

class _BuildingsGridViewState extends State<BuildingsGridView> {
  @override
  Widget build(BuildContext context) {
    final settlement = widget.settlement;
    return Scaffold(
      appBar: buildAppBar(),
      drawer: const MainDrawer(),
      body: Column(
        children: [
          const SizedBox(
            height: 3,
          ),
          StorageBar(
            settlement: settlement,
          ),
          Expanded(
            child: ReorderableGridView.count(
              padding: const EdgeInsets.all(10),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 3,
              dragWidgetBuilder: (index, child) {
                return Card(
                  color: DartopiaColors.primary,
                  child: child,
                );
              },
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  final element = settlement.buildings.removeAt(oldIndex + 18);
                  settlement.buildings.insert(newIndex + 18, element);
                });
                context.read<SettlementRepository>().reorderBuildings(
                    settlementId: settlement.id.$oid,
                    newBuildings: settlement.buildings);
              },
              header: _groupFieldsByType(settlement).map(
                (fieldRecord) {
                  final constructionTasks = settlement.constructionTasks
                      .where((task) => task.specificationId == fieldRecord[1])
                      .toList();
                  return _BuildingGridItem(
                    key: ValueKey('${fieldRecord[0]} ${fieldRecord[1]}'),
                    buildingRecord: fieldRecord,
                    constructionTask: constructionTasks.firstOrNull,
                    constructionsTaskAmount: settlement.constructionTasks.length,
                    storage: settlement.storage,
                    prodPerHour: settlement.calculateProducePerHour(),
                  );
                },
              ).toList(),
              footer: [
                _BuildingGridAddItem(
                    key: UniqueKey(),
                    buildingsAmount: settlement.buildings.length,
                    labelBackground: settlement.constructionTasks.length <
                            maxConstructionTasksAllowed
                        ? DartopiaColors.primaryContainer
                        : DartopiaColors.white38),
              ],
              children: settlement.buildingsExceptFieldsAndEmpty.map(
                (bRecord) {
                  final upgradingTasks = settlement.constructionTasks
                      .where((task) => task.buildingId == bRecord[0])
                      .toList();
                  return _BuildingGridItem(
                    key: ValueKey('${bRecord[0]} ${bRecord[1]}'),
                    buildingRecord: bRecord,
                    storage: settlement.storage,
                    constructionTask: upgradingTasks.firstOrNull,
                    constructionsTaskAmount: settlement.constructionTasks.length,
                  );
                },
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }

  List<List<int>> _groupFieldsByType(Settlement settlement) {
    List<List<int>> mockList = [
      [0, 0, 0, 0], [1, 1, 0, 0], [2, 2, 0, 0], [3, 3, 0, 0] //mock fields
    ];
    return mockList.map((mock) {
      final upgradableFields = settlement.buildings
          .where((buildingRecord) =>
              mock[1] == buildingRecord[1] &&
              (buildingRecord[3] == 1 || buildingRecord[3] == 2))
          .toList();
      return upgradableFields.isNotEmpty
          ? [...mock.sublist(0, 3), upgradableFields[0][3]]
          : mock;
    }).toList();
  }
}

class _BuildingGridItem extends StatelessWidget {
  const _BuildingGridItem({
    super.key,
    required this.buildingRecord,
    this.constructionTask,
    required this.constructionsTaskAmount,
    required this.storage,
    this.prodPerHour = const [0, 0, 0, 0],
  });

  final List<int> buildingRecord;
  final ConstructionTask? constructionTask;
  final int constructionsTaskAmount;
  final List<double> storage;
  final List<int> prodPerHour;

  @override
  Widget build(BuildContext context) {
    final (labelBackground, labelTextColor) = _getLabelColors();
    final id = buildingRecord[1];
    final lbl = id == 0 || id == 1 || id == 2 || id == 3
        ? prodPerHour[id].toString()
        : 'lvl ${buildingRecord[2]}';
    return Badge(
      label: Text(lbl),
      backgroundColor: DartopiaColors.primary,
      textColor: DartopiaColors.onPrimary,
      textStyle: Theme.of(context).textTheme.bodyMedium,
      offset: Offset(-1.0 * lbl.length, 0),
      largeSize: 22,
      smallSize: 0,
      child: Badge(
        alignment: Alignment.bottomLeft,
        label: _buildLabel(labelTextColor, context),
        textColor: DartopiaColors.onPrimary,
        backgroundColor: DartopiaColors.primary,
        offset: const Offset(0, 0),
        textStyle: Theme.of(context).textTheme.bodyMedium,
        largeSize: 22,
        child: GestureDetector(
          onTap: () {
            context.go('/buildings/details', extra: buildingRecord);
            //BuildingDetailsRoute($extra: buildingRecord).go(context);
          },
          child: Card(
            color: labelBackground,
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
              Text(buildingSpecefication[constructionTask!.specificationId]!
                  .name),
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
                textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: DartopiaColors.onPrimary,
                    ),
              ),
            ],
          );
  }

  (Color, Color) _getLabelColors() {
    final canBeUpgraded = buildingRecord[3] == 1 ? true : false;
    final canBeUpgradedWithGold = buildingRecord[3] == 2 ? true : false;
    Color labelBackground;
    Color labelTextColor;
    if (canBeUpgraded) {
      labelBackground = DartopiaColors.primaryContainer;
      labelTextColor = DartopiaColors.onPrimary;
    } else if (canBeUpgradedWithGold) {
      labelBackground = DartopiaColors.secondaryContainer;
      labelTextColor = Colors.black;
    } else {
      labelBackground = DartopiaColors.white38;
      labelTextColor = Colors.black;
    }
    return (labelBackground, labelTextColor);
  }
}

class _BuildingGridAddItem extends StatelessWidget {
  const _BuildingGridAddItem({
    super.key,
    required this.buildingsAmount,
    this.labelBackground = DartopiaColors.primary,
  });

  final int buildingsAmount;
  final Color labelBackground;

  @override
  Widget build(BuildContext context) {
    final availableEmptySpots = maxBuildings - buildingsAmount;
    return GestureDetector(
      onTap: () {
        context.go('/settlement/details', extra: [buildingsAmount, 99, 0, 0]);
      },
      child: Badge(
        alignment: Alignment.bottomRight,
        label: Text(availableEmptySpots.toString()),
        backgroundColor: DartopiaColors.primary,
        textStyle: Theme.of(context).textTheme.bodyMedium,
        offset: const Offset(5, 0),
        largeSize: 22,
        child: Card(
          color: labelBackground,
          child: const Center(
            child: Icon(Icons.add, color: DartopiaColors.black),
          ),
        ),
      ),
    );
  }
}
