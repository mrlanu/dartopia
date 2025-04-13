import 'package:dartopia/periodic_update/cubit/periodic_update_cubit.dart';
import 'package:dartopia/settlement/bloc/settlement_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../messages/cubit/messages_cubit.dart';
import '../../navigation/navigation.dart';
import '../../reports/bloc/reports_bloc.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettlementBloc, SettlementState>(
      listenWhen: (previous, current) =>
          previous.settlementList.isEmpty && current.settlementList.isNotEmpty,
      listener: (context, state) {
        context
            .read<PeriodicUpdateCubit>()
            .startPeriodicUpdates(state.settlementList[0].settlementId);
      },
      child: Scaffold(
        body: navigationShell,
        bottomNavigationBar: BottomNavBar(
          navigationShell: navigationShell,
        ),
      ),
    );
  }
}
