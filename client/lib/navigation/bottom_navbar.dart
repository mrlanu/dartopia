import 'package:dartopia/messages/messages.dart';
import 'package:dartopia/settlement/bloc/settlement_bloc.dart';
import 'package:dartopia/statistics/cubit/statistics_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../consts/colors.dart';
import '../reports/bloc/reports_bloc.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  void initState() {
    super.initState();
    context.read<ReportsBloc>().add(const ListOfBriefsRequested());
    context.read<MessagesCubit>().fetchMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          backgroundColor: DartopiaColors.primary,
          unselectedItemColor: DartopiaColors.white38,
          selectedItemColor: DartopiaColors.onPrimary,
          currentIndex: widget.navigationShell.currentIndex,
          onTap: (index) => _onTap(context, index),
          elevation: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          //selectedItemColor: bottomNavBarSelectedItem,
          //unselectedItemColor: bottomNavBarItem,
          type: BottomNavigationBarType.fixed,
          items: [
            const BottomNavigationBarItem(
                label: 'buildings',
                icon: FaIcon(FontAwesomeIcons.houseChimney)),
            const BottomNavigationBarItem(
                label: 'map', icon: FaIcon(FontAwesomeIcons.mapLocationDot)),
            const BottomNavigationBarItem(
                label: 'charts', icon: FaIcon(FontAwesomeIcons.chartLine)),
            _buildReportsBarItem(context),
            const BottomNavigationBarItem(
                label: 'mail', icon: FaIcon(FontAwesomeIcons.envelopeOpenText)),
          ],
        ));
  }

  void _onTap(BuildContext context, int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
    switch (index) {
      case 0:
        context.read<SettlementBloc>().add(const SettlementFetchRequested());
      case 2:
        context.read<StatisticsCubit>().fetchStatistics();
      case 3: context.read<ReportsBloc>().add(const ListOfBriefsRequested());
      case 4: context.read<MessagesCubit>().fetchMessages();
      default: throw const FormatException("Invalid");
    }
  }

  BottomNavigationBarItem _buildReportsBarItem(BuildContext context) {
    return BottomNavigationBarItem(
        label: 'reports',
        icon: BlocBuilder<ReportsBloc, ReportsState>(
          builder: (context, state) {
            return state.amount == 0
                ? const FaIcon(FontAwesomeIcons.book)
                : Badge(
                    label: Text('${state.amount}',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white)),
                    child: const FaIcon(FontAwesomeIcons.book),
                  );
          },
        ));
  }
}
