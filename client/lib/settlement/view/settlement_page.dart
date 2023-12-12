import 'package:dartopia/bottom_navbar/bottom_navbar.dart';
import 'package:dartopia/buildings/view/buildings_page.dart';
import 'package:dartopia/consts/consts.dart';
import 'package:dartopia/world_map/world_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/common.dart';
import '../../rally_point/rally_point.dart';
import '../settlement.dart';

class SettlementPage extends StatelessWidget {
  SettlementPage({super.key});

  final SettlementRepository _settlementRepository = SettlementRepositoryImpl();
  final TroopMovementsRepository _movementsRepository =
      TroopMovementsRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => _settlementRepository,
        ),
        RepositoryProvider(
          create: (context) => _movementsRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => NavigationCubit()),
          BlocProvider(
            create: (context) => SettlementBloc(
                settlementRepository: context.read<SettlementRepository>())
              ..add(const ListOfSettlementsRequested(userId: 'Nata')),
          ),
          BlocProvider(
            create: (context) =>
                MovementsBloc(movementsRepository: _movementsRepository)
                  ..add(const MovementsSubscriptionRequested()),
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
          drawer: const Drawer(),
          body: BlocListener<SettlementBloc, SettlementState>(
            listenWhen: (previous, current) =>
                previous.settlement != current.settlement,
            listener: (context, state) {
              context.read<MovementsBloc>().add(MovementsFetchRequested(
                  settlementId: state.settlement!.id.$oid));
            },
            child: IndexedStack(
              index: selectedTab.index,
              children: [
                const BuildingsPage(),
                WorldMapPage(),
                const Scaffold()
              ],
            ),
          ),
          bottomNavigationBar: const BottomNavBar()),
    );
  }
}
