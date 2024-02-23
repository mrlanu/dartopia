import 'package:dartopia/consts/consts.dart';
import 'package:dartopia/settlement/bloc/settlement_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../buildings/view/building_widgets/building_widgets_factory.dart';

class BuildingDetailPage extends StatelessWidget {
  const BuildingDetailPage(
      {super.key, required this.settlementBloc, required this.buildingRecord});

  final SettlementBloc settlementBloc;
  final List<int> buildingRecord;

  static Route<void> route(
      {required List<int> buildingRecord, required SettlementBloc block}) {
    return MaterialPageRoute(
      builder: (context) {
        return BuildingDetailPage(
          settlementBloc: block,
          buildingRecord: buildingRecord,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: settlementBloc,
      child: BuildingDetailView(buildingRecord: buildingRecord),
    );
    BuildingDetailView(
      buildingRecord: buildingRecord,
    );
  }
}

class BuildingDetailView extends StatelessWidget {
  const BuildingDetailView({super.key, required this.buildingRecord});

  final List<int> buildingRecord;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: background,
          appBar: AppBar(),
          body: BuildingWidgetsFactory.get(buildingRecord)),
    );
  }
}
