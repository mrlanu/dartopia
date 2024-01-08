import 'package:dartopia/authentication/bloc/auth_bloc.dart';
import 'package:dartopia/bottom_navbar/bottom_navbar.dart';
import 'package:dartopia/buildings/view/buildings_page.dart';
import 'package:dartopia/consts/consts.dart';
import 'package:dartopia/drawer/main_drawer.dart';
import 'package:dartopia/world_map/world_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/common.dart';
import '../../rally_point/rally_point.dart';
import '../../reports/reports.dart';
import '../settlement.dart';

class SettlementPage extends StatelessWidget {
  const SettlementPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const SettlementPage());
  }

  @override
  Widget build(BuildContext context) {
    final token = context.read<AuthBloc>().state.token;
    final SettlementRepository settlementRepository =
        SettlementRepositoryImpl(token: token);
    final TroopMovementsRepository movementsRepository =
        TroopMovementsRepositoryImpl(token: token);
    final ReportsRepository reportsRepository =
        ReportsRepositoryImpl(token: token);
    final userId = context.read<AuthBloc>().state.userId;
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => settlementRepository,
        ),
        RepositoryProvider(
          create: (context) => movementsRepository,
        ),
        RepositoryProvider(
          create: (context) => reportsRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => NavigationCubit()),
          BlocProvider(
            create: (context) => SettlementBloc(
                settlementRepository: context.read<SettlementRepository>())
              ..add(ListOfSettlementsRequested(userId: userId)),
          ),
          BlocProvider(
            create: (context) =>
                MovementsBloc(movementsRepository: movementsRepository)
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
          backgroundColor: background,
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
                          const BuildingsPage(),
                          WorldMapPage(),
                          Container(),
                          ReportsPage(),
                          const Scaffold()
                        ],
                      );
              }),
          bottomNavigationBar: const BottomNavBar()),
    );
  }
}
