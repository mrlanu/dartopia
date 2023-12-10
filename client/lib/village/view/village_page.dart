import 'package:dartopia/bottom_navbar/bottom_navbar.dart';
import 'package:dartopia/buildings/view/buildings_page.dart';
import 'package:dartopia/consts/consts.dart';
import 'package:dartopia/world_map/world_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../buildings/buildings.dart';
import '../../common/common.dart';
import '../../rally_point/rally_point.dart';
import '../cubit/navigation_cubit.dart';
import '../repository/settlement_repository.dart';

class VillagePage extends StatelessWidget {
  VillagePage({super.key});

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
          BlocProvider(
            create: (context) => NavigationCubit(),
          ),
          BlocProvider(
            create: (context) => BuildingsBloc(
                settlementRepository: context.read<SettlementRepository>())
              ..add(const SettlementSubscriptionRequested()),
          ),
          BlocProvider(
            create: (context) =>
                MovementsBloc(movementsRepository: _movementsRepository)
                  ..add(const MovementsSubscriptionRequested()),
          )
        ],
        child: const VillageView(),
      ),
    );
  }
}

class VillageView extends StatelessWidget {
  const VillageView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedTab =
        context.select((NavigationCubit cubit) => cubit.state.tab);

    return SafeArea(
      child: Scaffold(
          backgroundColor: background,
          appBar: buildAppBar(),
          drawer: const Drawer(),
          body: IndexedStack(
            index: selectedTab.index,
            children: [const BuildingsPage(), WorldMapPage(), const Scaffold()],
          ),
          bottomNavigationBar: const BottomNavBar()),
    );
  }
}
