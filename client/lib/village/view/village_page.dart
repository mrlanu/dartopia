import 'package:dartopia/bottom_navbar/bottom_navbar.dart';
import 'package:dartopia/buildings/view/buildings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/village_bloc.dart';
import '../cubit/navigation_cubit.dart';
import '../repository/village_repository.dart';

class VillagePage extends StatelessWidget {
  const VillagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => VillageRepositoryImpl(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => NavigationCubit(),
          ),
          BlocProvider(
            create: (context) => VillageBloc(
                villageRepository: context.read<VillageRepositoryImpl>())
              ..add(const VillageFetchRequested(villageId: 'villageId')),
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
    final selectedTab = context.select((NavigationCubit cubit) =>
    cubit.state.tab);

    return SafeArea(
      child: Scaffold(
          body: IndexedStack(
            index: selectedTab.index,
            children: const [BuildingsPage(), Scaffold()],
          ),
          bottomNavigationBar: const BottomNavBar()
      ),
    );
  }
}
