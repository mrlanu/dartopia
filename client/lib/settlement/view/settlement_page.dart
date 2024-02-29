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
  const SettlementPage({super.key, required this.token});

  final String token;

  static Route<void> route({required String token}) {
    return MaterialPageRoute<void>(
        builder: (_) => SettlementPage(
              token: token,
            ));
  }

  @override
  State<SettlementPage> createState() => _SettlementPageState();
}

class _SettlementPageState extends State<SettlementPage> {
  late final SettlementRepository _settlementRepository;
  late final TroopMovementsRepository _troopMovementsRepository;
  late final ReportsRepository _reportsRepository;

  @override
  void initState() {
    _settlementRepository = SettlementRepositoryImpl(token: widget.token);
    _troopMovementsRepository =
        TroopMovementsRepositoryImpl(token: widget.token);
    _reportsRepository = ReportsRepositoryImpl(token: widget.token);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => _settlementRepository,
        ),
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
            create: (context) => SettlementBloc(
                settlementRepository: context.read<SettlementRepository>())
              ..add(const ListOfSettlementsRequested()),
          ),
          BlocProvider(
            create: (context) =>
                MovementsBloc(movementsRepository: _troopMovementsRepository)
                  ..add(const MovementsSubscriptionRequested()),
          ),
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
          body: BlocConsumer<SettlementBloc, SettlementState>(
              listenWhen: (previous, current) =>
                  previous.settlement != current.settlement,
              listener: (context, state) {
                context.read<MovementsBloc>().add(MovementsFetchRequested(
                    settlementId: state.settlement!.id.$oid));
              },
              builder: (context, state) {
                return state.status == SettlementStatus.loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : IndexedStack(
                        index: selectedTab.index,
                        children: [
                          BuildingsPageGrid(settlement: state.settlement!),
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
