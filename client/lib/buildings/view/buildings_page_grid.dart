import 'package:dartopia/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

import '../../building_detail/view/building_detail_page.dart';
import '../../settlement/bloc/settlement_bloc.dart';
import '../../storage_bar/view/storage_bar.dart';
import '../buildings.dart';

class BuildingsPageGrid extends StatelessWidget {
  const BuildingsPageGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettlementBloc, SettlementState>(
        builder: (context, state) {
      return state.status == SettlementStatus.loading
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : BuildingsGridView(
              settlement: state.settlement!,
              buildingRecords: state.buildingRecords,
            );
    });
  }
}

class BuildingsGridView extends StatefulWidget {
  const BuildingsGridView(
      {super.key, required this.settlement, required this.buildingRecords});

  final List<List<int>> buildingRecords;
  final Settlement settlement;

  @override
  State<BuildingsGridView> createState() => _BuildingsPage2State();
}

class _BuildingsPage2State extends State<BuildingsGridView> {
  @override
  Widget build(BuildContext context) {
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
            dragWidgetBuilder: (index, child) {
              return Card(
                color: const Color.fromRGBO(36, 126, 38, 1.0),
                child: child,
              );
            },
            padding: const EdgeInsets.all(10),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 3,
            onReorder: (oldIndex, newIndex) {
              setState(() {
                final element = widget.buildingRecords.removeAt(oldIndex);
                widget.buildingRecords.insert(newIndex, element);
              });
            },
            footer: const [
              Card(
                color: background3,
                child: Center(
                  child: Icon(Icons.add),
                ),
              ),
            ],
            children: widget.buildingRecords.map(
              (bRecord) {
                final building = buildingSpecefication[bRecord[1]];
                return Badge(
                  key: UniqueKey(),
                  label: Text(bRecord[2].toString()),
                  backgroundColor: primary,
                  textStyle: Theme.of(context).textTheme.bodyMedium,
                  offset: const Offset(5, 0),
                  largeSize: 22,
                  child: Badge(
                    alignment: Alignment.bottomLeft,
                    label: Text(building!.name),
                    backgroundColor: primary,
                    offset: const Offset(0, 0),
                    textStyle: Theme.of(context).textTheme.bodyMedium,
                    largeSize: 22,
                    child: GestureDetector(
                      onTap: () {
                        final settlementBloc = context.read<SettlementBloc>();
                        Navigator.of(context).push(BuildingDetailPage.route(
                            block: settlementBloc, buildingRecord: bRecord));
                      },
                      child: Card(
                        color: background3,
                        child: BuildingPicture(
                          buildingRecord: bRecord,
                          prodPerHour: null,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        ),
      ],
    );
  }
}
