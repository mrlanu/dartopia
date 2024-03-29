import 'package:dartopia/bottom_navbar/bottom_navbar.dart';
import 'package:dartopia/buildings/buildings.dart';
import 'package:dartopia/buildings/view/buildings_page_grid.dart';
import 'package:dartopia/consts/calors.dart';
import 'package:dartopia/drawer/main_drawer.dart';
import 'package:dartopia/world_map/world_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/common.dart';
import '../../rally_point/rally_point.dart';
import '../../reports/reports.dart';
import '../settlement.dart';

class SettlementPage extends StatefulWidget {
  const SettlementPage({super.key});

  @override
  State<SettlementPage> createState() => _SettlementPageState();
}

class _SettlementPageState extends State<SettlementPage> {
  late final TroopMovementsRepository _troopMovementsRepository;
  late final ReportsRepository _reportsRepository;

  @override
  void initState() {
    _troopMovementsRepository =
        TroopMovementsRepositoryImpl();
    _reportsRepository = ReportsRepositoryImpl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => _troopMovementsRepository,
        ),
        RepositoryProvider(
          create: (context) => _reportsRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => NavigationCubit()),
          BlocProvider(
            create: (context) => ReportsBloc(
                reportsRepository: context.read<ReportsRepository>())
              ..add(const ListOfBriefsRequested()),
          )
        ],
        child: const SettlementView(),
      ),
    );
  }
}

class SettlementView extends StatelessWidget {
  const SettlementView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedTab =
        context.select((NavigationCubit cubit) => cubit.state.tab);
    return SafeArea(
      child: Scaffold(
          backgroundColor: DartopiaColors.background,
          appBar: buildAppBar(),
          drawer: const MainDrawer(),
          body: BlocBuilder<SettlementBloc, SettlementState>(
              builder: (context, state) {
            return state.status == SettlementStatus.loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : IndexedStack(
                    index: selectedTab.index,
                    children: [
                      BuildingsPageGrid(key: UniqueKey(), settlement: state.settlement!),
                      //BuildingsPage(),
                      const WorldMapPage(),
                      Container(),
                      const ReportsPage(),
                      const Scaffold()
                    ],
                  );
          }),
          bottomNavigationBar: const BottomNavBar()),
    );
  }
}
