import 'package:dartopia/bottom_navbar/bottom_navbar.dart';
import 'package:dartopia/buildings/view/buildings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../buildings/buildings.dart';
import '../cubit/navigation_cubit.dart';
import '../repository/settlement_repository.dart';

class VillagePage extends StatelessWidget {
  const VillagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => SettlementRepositoryImpl(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => NavigationCubit(),
          ),
          BlocProvider(
            create: (context) => BuildingsBloc(
                settlementRepository: context.read<SettlementRepositoryImpl>())
              ..add(const SettlementSubscriptionRequested()),
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
          appBar: _buildAppBar(),
          drawer: const Drawer(),
          body: IndexedStack(
            index: selectedTab.index,
            children: const [BuildingsPage(), Scaffold()],
          ),
          bottomNavigationBar: const BottomNavBar()),
    );
  }

  PreferredSizeWidget _buildAppBar() => AppBar(
        centerTitle: true,
        title: const Text(''),
        actions: [
          IconButton(
              onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.gear))
        ],
        //backgroundColor: transparent,
        elevation: 0,
      );
}
